/*-- Name: fn_ListFind
-- Author: Danny Goodisman
-- Date: 3/25/2004
-- Description: This function tests whether the specified search parameter is any item in a list
--	The list items are restricted to a max length of 150 characters and the whole list is restricted to 5000

CREATE FUNCTION fn_ListFind (@list varchar(5000), @param varchar(150))  
RETURNS varchar(150) AS  

BEGIN 

declare @return int
declare @listposition int

set @return = 0
set @listposition = 1

WHILE  (@listposition <= dbo.fn_ListLen(@list) ) 
	begin
		if (@param = dbo.fn_ListGetAt ( @list, @listposition)  ) begin set @return = 1 break end

		set @listposition = @listposition + 1
	END

return @return
END*/









