/*-- Name: fn_ListLen
-- Author: Danny Goodisman
-- Date: 4/01/2004
-- Description: This function returns the number of items in a list
--	The length of the list is restricted to 5000

CREATE FUNCTION fn_ListLen (@list varchar(5000))  
RETURNS int AS  

BEGIN 

declare @return int
declare @listposition int
declare @listremainder varchar(5000)

set @listremainder = @list
set @listposition = 0
set @return = 1
WHILE  (charindex(',', @listremainder) > 0) 
	begin
		set @listremainder = right(@listremainder, len(@listremainder) - charindex(',', @listremainder)-1 )
		set @return = @return + 1
	END

return @return
END*/








