/*CREATE FUNCTION fn_remove_alpha    (@inputstring varchar(1000) )
RETURNS varchar(3000)
AS
BEGIN
	declare @outputstring varchar(3000)
	set @outputstring = @inputstring
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
	set @outputstring = replace(@outputstring, '-', '')
	set @outputstring = replace(@outputstring, ' ', '')
	set @outputstring = replace(@outputstring,'#', '')
	set @outputstring = replace(@outputstring, '_', '')
	set @outputstring = replace(@outputstring,'$', '')
	set @outputstring = replace(@outputstring,'&', '')
	set @outputstring = replace(@outputstring,';', '')
	set @outputstring = replace(@outputstring,'A', '')
	set @outputstring = replace(@outputstring,'B', '')
	set @outputstring = replace(@outputstring,'C', '')
	set @outputstring = replace(@outputstring,'D', '')
	set @outputstring = replace(@outputstring,'E', '')
	set @outputstring = replace(@outputstring,'F', '')
	set @outputstring = replace(@outputstring,'G', '')
	set @outputstring = replace(@outputstring,'H', '')
	set @outputstring = replace(@outputstring,'I', '')
	set @outputstring = replace(@outputstring,'J', '')
	set @outputstring = replace(@outputstring,'K', '')
	set @outputstring = replace(@outputstring,'L', '')
	set @outputstring = replace(@outputstring,'M', '')
	set @outputstring = replace(@outputstring,'N', '')
	set @outputstring = replace(@outputstring,'O', '')
	set @outputstring = replace(@outputstring,'P', '')
	set @outputstring = replace(@outputstring,'Q', '')
	set @outputstring = replace(@outputstring,'R', '')
	set @outputstring = replace(@outputstring,'S', '')
	set @outputstring = replace(@outputstring,'T', '')
	set @outputstring = replace(@outputstring,'U', '')
	set @outputstring = replace(@outputstring,'V', '')
	set @outputstring = replace(@outputstring,'W', '')
	set @outputstring = replace(@outputstring,'X', '')
	set @outputstring = replace(@outputstring,'Y', '')
	set @outputstring = replace(@outputstring,'Z', '')

	RETURN ( @outputstring )
END*/













