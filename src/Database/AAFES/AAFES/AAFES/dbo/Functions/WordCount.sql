
CREATE FUNCTION [dbo].[WordCount] (@input text)  
RETURNS int AS  
BEGIN 
declare @wordcount int
declare @inputstring varchar(8000)
set @inputstring = Cast(@input as varchar(8000))
set @inputstring = replace(@inputstring, '  ', ' ')

if Len(@inputstring) = 0 set @wordcount =0
	else set @wordcount = 1 + Len(@inputstring) - Len(replace(@inputstring, ' ', ''))

return @wordcount
END