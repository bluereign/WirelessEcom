/*-- Name: fn_ForeignKeys
-- Author: Danny Goodisman
-- Date: 11/16/2005
-- Description: This user-defined function generates the column list for a table. This routine cannot be a stored procedure because it must be called from another stored procedure
--	Sample Usage: select @column_list = dbo.fn_Generate_Column_List ('Users')
--

CREATE FUNCTION dbo.fn_ForeignKeys ( @tableName varchar(100) )  
RETURNS varchar(8000) 
AS  
BEGIN 

declare @sql varchar(8000)

If exists (Select * from Information_Schema.COLUMNS where Table_Name=@tableName)
	begin
	exec sp_fkeys Orders
	End
Else
	select @sql= 'The table '+@tableName + ' does not exist'

return @sql

END*/





