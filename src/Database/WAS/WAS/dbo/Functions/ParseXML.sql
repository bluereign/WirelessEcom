
CREATE FUNCTION [dbo].[ParseXML] (@XML_Result XML)
/* 
Returns a hierarchy table from an XML document.
Author: Phil Factor
Revision: 1.2
date: 1 May 2014
example:

DECLARE @MyHierarchy Hierarchy
INSERT INTO @myHierarchy
select * from dbo.ParseXML((Select * from adventureworks.person.contact where contactID in (123,124,125) FOR XML path('contact'), root('contacts')))
SELECT dbo.ToJSON(@MyHierarchy)

DECLARE @MyHierarchy Hierarchy
INSERT INTO @myHierarchy
select * from dbo.ParseXML('<root><CSV><item Year="1997" Make="Ford" Model="E350" Description="ac, abs, moon" Price="3000.00" /><item Year="1999" Make="Chevy" Model="Venture &quot;Extended Edition&quot;" Description="" Price="4900.00" /><item Year="1999" Make="Chevy" Model="Venture &quot;Extended Edition, Very Large&quot;" Description="" Price="5000.00" /><item Year="1996" Make="Jeep" Model="Grand Cherokee" Description="MUST SELL!&#xD;&#xA;air, moon roof, loaded" Price="4799.00" /></CSV></root>')
SELECT dbo.ToJSON(@MyHierarchy)

*/
RETURNS @Hierarchy TABLE (
	Element_ID INT PRIMARY KEY, /* internal surrogate primary key gives the order of parsing and the list order */
	SequenceNo INT NULL, /* the sequence number in a list */
	Parent_ID INT,/* if the element has a parent then it is in this column. The document is the ultimate parent, so you can get the structure from recursing from the document */
	[object_id] INT,/* each list or object has an object id. This ties all elements to a parent. Lists are treated as objects here */
	[Name] NVARCHAR(2000),/* the name of the object */
	StringValue NVARCHAR(MAX) NOT NULL,/*the string representation of the value of the element. */
	ValueType VARCHAR(10) NOT NULL /* the declared type of the value represented as a string in StringValue*/
)
AS
BEGIN
	DECLARE @Insertions TABLE (
		Element_ID INT IDENTITY PRIMARY KEY,
		SequenceNo INT,
		TheLevel INT,
		Parent_ID INT,
		[object_id] INT,
		[Name] VARCHAR(50),
		StringValue VARCHAR(MAX),
		ValueType VARCHAR(10),
		TheNextLevel XML,
		ThisLevel XML
	)

	DECLARE	@RowCount INT,
			@ii INT
	--get the 
	INSERT INTO @Insertions (TheLevel, Parent_ID, [object_id], [Name], StringValue, SequenceNo, TheNextLevel, ThisLevel)
		SELECT
			1 AS TheLevel,
			NULL AS Parent_ID,
			NULL AS [object_id],
			FirstLevel.value('local-name(.)', 'varchar(255)') AS [Name], --the name of the element
			FirstLevel.value('text()[1]', 'varchar(max)') AS StringValue,-- its value as a string
			ROW_NUMBER() OVER (ORDER BY (SELECT
				1)
			) AS SequenceNo,--the 'child number' (simple number here)
			FirstLevel.query('*'), --The 'inner XML' of the current child  
			FirstLevel.query('.')  --the XML of the parent
		FROM @XML_Result.nodes('/*') a (FirstLevel) --get all nodes from the XML
	SELECT
		@RowCount = @@rowcount
	SELECT
		@ii = 2
	WHILE @RowCount > 0 --while loop to avoid recursion.
	BEGIN
		INSERT INTO @Insertions (TheLevel, Parent_ID, [object_id], [Name], StringValue, SequenceNo, TheNextLevel, ThisLevel)
			SELECT --all the elements first
				@ii AS TheLevel,
				a.Element_ID,
				NULL,
				[then].value('local-name(.)', 'varchar(255)'),
				[then].value('text()[1]', 'varchar(max)'),
				ROW_NUMBER() OVER (PARTITION BY a.Element_ID ORDER BY (SELECT
					1)
				),
				[then].query('*'),
				[then].query('.')
			FROM @Insertions a
			CROSS APPLY a.TheNextLevel.nodes('*') whatsNext ([then])
			WHERE a.TheLevel = @ii - 1
			UNION ALL -- to pick out the attributes of the preceding level
			SELECT
				@ii AS TheLevel,
				a.Element_ID,
				NULL,
				[then].value('local-name(.)', 'varchar(255)') AS [name],
				[then].value('.', 'varchar(max)') AS [value],
				ROW_NUMBER() OVER (PARTITION BY a.Element_ID
				ORDER BY (SELECT
					1)
				),
				'',
				''
			FROM @Insertions a
			CROSS APPLY a.ThisLevel.nodes('/*/@*') whatsNext ([then])
			WHERE a.TheLevel = @ii - 1
			OPTION (RECOMPILE)
		SELECT
			@RowCount = @@rowcount
		SELECT
			@ii = @ii + 1
	END;
	--roughly type the datatypes (no XSD available here) 
	UPDATE @Insertions
	SET	[object_id] =
						CASE
							WHEN StringValue IS NULL THEN Element_ID
							ELSE NULL
						END,
		ValueType =
					CASE
						WHEN StringValue IS NULL THEN 'object'
						WHEN LEN(StringValue) = 0 THEN 'string'
						WHEN StringValue LIKE '%[^0-9.-]%' THEN 'string'
						WHEN StringValue LIKE '[0-9]' THEN 'int'
						WHEN RIGHT(StringValue, LEN(StringValue) - 1) LIKE '%[^0-9.]%' THEN 'string'
						WHEN StringValue LIKE '%[0-9][.][0-9]%' THEN 'real'
						WHEN StringValue LIKE '%[^0-9]%' THEN 'string'
						ELSE 'int'
					END--and find the arrays
	UPDATE @Insertions
	SET ValueType = 'array'
	WHERE Element_ID IN (SELECT
		candidates.Parent_ID
	FROM (SELECT
		Parent_ID,
		COUNT(*) AS SameName
	FROM @Insertions
	GROUP BY	[Name],
				Parent_ID
	HAVING COUNT(*) > 1) candidates
	INNER JOIN @Insertions insertions
		ON candidates.Parent_ID = insertions.Parent_ID
	GROUP BY candidates.Parent_ID
	HAVING COUNT(*) = MIN(SameName))
	INSERT INTO @Hierarchy (Element_ID, SequenceNo, Parent_ID, [object_id], [Name], StringValue, ValueType)
		SELECT
			Element_ID,
			SequenceNo,
			Parent_ID,
			[object_id],
			[Name],
			COALESCE(StringValue, ''),
			ValueType
		FROM @Insertions
	RETURN
END