--**************************************
--     
-- Name: Capitalize First Letter
-- Description:This is a User Defined Fu
--     nction (UDF) that will capitalize the fi
--     rst letter of a character after a space.
--      It will also lowercase all capitalized 
--     words. This will only capitalize the fir
--     st letter after the any space. Example: 
--     'A CAT RAN DOWN' --> 'A Cat Ran Down'
--      or 'a cat ran down' --> 'A Cat Ran D
--     own'. Usage Select CapFirst('String')
-- By: Adonis Villanueva
--
-- Inputs:String input
--
-- Returns:Formatted String
--
--This code is copyrighted and has-- limited warranties.Please see http://
--     www.Planet-Source-Code.com/vb/scripts/Sh
--     owCode.asp?txtCodeId=663&lngWId=5--for details.--**************************************
--     

CREATE function dbo.CapFirst (@String varchar(255))
returns varchar(255)
as


    BEGIN --begin function PROCEDURE
    DECLARE @StringCount int
    SET @string = lower(@string)
    SET @string = stuff(@string,1,1,left(upper(@string),1)) --Capitalize the first letter 
    SET @StringCount = 0
    WHILE @StringCount < len(@string)


        BEGIN --begin WHILE
         IF substring(@string,charindex(space(1),@string,@StringCount),1) = space(1)


             BEGIN --begin IF	
            SET @string = stuff(@string,charindex(space(1),@string,@StringCount)+1,1,substring(upper(@string),charindex(' ',@string,@StringCount)+1,1)) 
         END --end IF
        SET @StringCount = @StringCount + 1
    END --end WHILE
    RETURN @string --return the formatted string
END --end function PROCEDURE