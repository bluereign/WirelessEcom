

CREATE FUNCTION [util].[ReplaceHTML] (@Text nvarchar(max))
	RETURNS nvarchar(max)
AS

BEGIN
	DECLARE @NewText nvarchar(max)=@Text

	SET @NewText=REPLACE(@NewText,('<p>'+CHAR(13)),'')
	SET @NewText=REPLACE(@NewText,'</p>','')
	SET @NewText=REPLACE(@NewText,'<br />','')
	SET @NewText=REPLACE(@NewText,'&nbsp;',' ') -- space
	SET @NewText=REPLACE(@NewText,'&#39;',CHAR(39)) --'
	SET @NewText=REPLACE(@NewText,'&amp;',CHAR(38)) --&
	SET @NewText=REPLACE(@NewText,CHAR(13),'  ') --CR
	SET @NewText=REPLACE(@NewText,CHAR(9),'') --TAB
	
	RETURN @NewText
END