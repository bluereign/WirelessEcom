/*CREATE FUNCTION dbo.fn_telephone_keypad    (@inputstring varchar(1000) )
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
	set @outputstring = replace(@outputstring,'A', '2')
	set @outputstring = replace(@outputstring,'B', '2')
	set @outputstring = replace(@outputstring,'C', '2')
	set @outputstring = replace(@outputstring,'D', '3')
	set @outputstring = replace(@outputstring,'E', '3')
	set @outputstring = replace(@outputstring,'F', '3')
	set @outputstring = replace(@outputstring,'G', '4')
	set @outputstring = replace(@outputstring,'H', '4')
	set @outputstring = replace(@outputstring,'I', '4')
	set @outputstring = replace(@outputstring,'J', '5')
	set @outputstring = replace(@outputstring,'K', '5')
	set @outputstring = replace(@outputstring,'L', '5')
	set @outputstring = replace(@outputstring,'M', '6')
	set @outputstring = replace(@outputstring,'N', '6')
	set @outputstring = replace(@outputstring,'O', '6')
	set @outputstring = replace(@outputstring,'P', '7')
	set @outputstring = replace(@outputstring,'Q', '7')
	set @outputstring = replace(@outputstring,'R', '7')
	set @outputstring = replace(@outputstring,'S', '7')
	set @outputstring = replace(@outputstring,'T', '8')
	set @outputstring = replace(@outputstring,'U', '8')
	set @outputstring = replace(@outputstring,'V', '8')
	set @outputstring = replace(@outputstring,'W', '9')
	set @outputstring = replace(@outputstring,'X', '9')
	set @outputstring = replace(@outputstring,'Y', '9')
	set @outputstring = replace(@outputstring,'Z', '9')

	RETURN ( @outputstring )
END*/















