/*CREATE FUNCTION dbo.udf_List2Table
(
	@List varchar(MAX),
	@Delim char
)
RETURNS
@ParsedList table
(
	item varchar(MAX)
)
AS
BEGIN
	DECLARE @item varchar(MAX)
	      , @Pos int;
	      
	SET @List = LTRIM(RTRIM(@List))+ @Delim;
	SET @Pos = CHARINDEX(@Delim, @List, 1);
	
	WHILE (@Pos > 0)
		BEGIN
			SET @item = LTRIM(RTRIM(LEFT(@List, @Pos - 1)));
			IF @item <> ''
				BEGIN
					INSERT INTO @ParsedList (item)
					VALUES (CAST(@item AS VARCHAR(MAX)));
				END
			SET @List = RIGHT(@List, LEN(@List) - @Pos);
			SET @Pos = CHARINDEX(@Delim, @List, 1);
		END
		
	RETURN;
END*/
