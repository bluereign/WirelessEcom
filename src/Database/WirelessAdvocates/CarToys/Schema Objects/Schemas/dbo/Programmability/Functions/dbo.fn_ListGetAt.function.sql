/*-- Name: fn_ListGetAt
-- Author: Danny Goodisman
-- Date: 3/25/2004
-- Description: This function gets the specified item in a list, for example dbo.fn_ListGetAt('A,B,C,D',3) will return '3'
--	The list items are restricted to a max length of 150 characters and the whole list is restricted to 5000

CREATE FUNCTION fn_ListGetAt (@list varchar(5000), @position int)  
RETURNS varchar(150) AS  

BEGIN 

declare @return varchar(150)
declare @listremainder varchar(5000)
declare @listitem int

-- If it's a one-item list
if charindex(',', @list) = 0 
	begin 
		if (@position = 1) begin	set @return = @list	end
		else begin set @return = null end
	end
-- If it's a more-then-one-item list
else 
	begin 
	-- If the first item is requested
	if (@position = 1) begin	set @return = left(@list, charindex(',', @list)-1)	end
	-- If a later item is requested
	else 
		begin 
		set @listremainder = @list
		set @listitem = 1
		WHILE @listitem < @position
			BEGIN
				set @listitem = @listitem + 1
				if (charindex(',', @listremainder)=0) begin	set @return = null	break 	end
				else
					begin
					set @listremainder = right(@listremainder, len(@listremainder) - charindex(',', @listremainder) )
					set @return = left(@listremainder, charindex(',', @listremainder))
					set @return = replace(@return, ',', '')
					if (charindex(',', @listremainder)=0 and @position <= @listitem) 
						begin	set @return = @listremainder	break 	end
					end
			END
		end
	end

return @return
END*/





