/*CREATE FUNCTION fn_URLformat    (@inputstring varchar(1000) )
RETURNS varchar(3000)
AS
BEGIN
	declare @outputstring varchar(3000)
	set @outputstring = ltrim(rtrim(@inputstring))
	set @outputstring = replace(@outputstring, ':', '')
	set @outputstring = replace(@outputstring, '+', '')
	set @outputstring = replace(@outputstring, '=', '')
	set @outputstring = replace(@outputstring, ')', '')
	set @outputstring = replace(@outputstring, '(', '')
	set @outputstring = replace(@outputstring, ']', '')
	set @outputstring = replace(@outputstring, '[', '')
	set @outputstring = replace(@outputstring, '{', '')
	set @outputstring = replace(@outputstring, '}', '')
	set @outputstring = replace(@outputstring, '/', '')
	set @outputstring = replace(@outputstring, '.', '')
	set @outputstring = replace(@outputstring, '"', '')
	set @outputstring = replace(@outputstring, '-', '')
	set @outputstring = replace(@outputstring,'#', '')
	set @outputstring = replace(@outputstring, '_', '')
	set @outputstring = replace(@outputstring,'$', '')
	set @outputstring = replace(@outputstring,'&', '')
	set @outputstring = replace(@outputstring,';', '')
	set @outputstring = replace(@outputstring,',', '')
	set @outputstring = replace(@outputstring, ' ', '_')
	set @outputstring = replace(@outputstring, '__', '_')

	RETURN ( @outputstring )
END*/



















