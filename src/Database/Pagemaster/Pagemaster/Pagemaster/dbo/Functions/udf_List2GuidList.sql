CREATE FUNCTION dbo.udf_List2GuidList
(
	@List varchar(max),
	@Delim char
)
RETURNS @ParsedList TABLE (item uniqueidentifier)
AS
BEGIN
	DECLARE @item varchar(max)
	      , @Pos int;
	      
	SET @List = LTRIM(RTRIM(@List))+ @Delim;
	SET @Pos = CHARINDEX(@Delim, @List, 1);
	
	WHILE (@Pos > 0)
		BEGIN
			SET @item = LTRIM(RTRIM(LEFT(@List, @Pos - 1)));
			IF @item <> ''
				BEGIN
					INSERT INTO @ParsedList (item)
					VALUES (convert(uniqueidentifier, @item));
				END
				
			SET @List = RIGHT(@List, LEN(@List) - @Pos);
			SET @Pos = CHARINDEX(@Delim, @List, 1);
		END
		
	RETURN;
END