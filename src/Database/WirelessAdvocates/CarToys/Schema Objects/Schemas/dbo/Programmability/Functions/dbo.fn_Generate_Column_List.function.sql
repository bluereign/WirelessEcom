/*-- Name: fn_Generate_Column_List
-- Author: Danny Goodisman
-- Date: 11/16/2005
-- Description: This user-defined function generates the column list for a table. This routine cannot be a stored procedure because it must be called from another stored procedure
--	Sample Usage: select @column_list = dbo.fn_Generate_Column_List ('Users')
--

CREATE FUNCTION fn_Generate_Column_List ( @tableName varchar(100) )  
RETURNS varchar(8000) 
AS  
BEGIN 

If exists (Select * from Information_Schema.COLUMNS where Table_Name=@tableName)
	Begin
	declare @sql varchar(8000)

	set @sql=''
	Select @sql=@sql
		+case when charindex('(',@sql,1) <= 0 then '' else '' end + Column_Name + ', ' 
	from Information_Schema.COLUMNS 
	where Table_Name=@tableName

	select @sql= substring(@sql,1,len(@sql)-1)
	End
Else
	select @sql= 'The table '+@tableName + ' does not exist'

return @sql

END*/


