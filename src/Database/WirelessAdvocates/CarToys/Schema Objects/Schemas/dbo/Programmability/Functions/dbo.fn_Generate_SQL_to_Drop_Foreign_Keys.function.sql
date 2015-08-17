/*-- Name: fn_Generate_SQL_to_Drop_Foreign_Keys
-- Author: Danny Goodisman
-- Date: 11/16/2005
-- Description: This user-defined function generates the column list for a table. This routine cannot be a stored procedure because it must be called from another stored procedure
--	Sample Usage: select @column_list = dbo.fn_Generate_Column_List ('Users')
--

CREATE FUNCTION fn_Generate_SQL_to_Drop_Foreign_Keys ( @table_server varchar(100),
    @pktab_name         sysname = null,
    @pktab_schema       sysname = null,
    @pktab_catalog      sysname = null,
    @fktab_name         sysname = null,
    @fktab_schema       sysname = null,
    @fktab_catalog      sysname = null
 )  
RETURNS varchar(8000) 
AS  
BEGIN 

If exists (Select * from Information_Schema.COLUMNS where Table_Name=@table_server )
	Begin
	declare @sql varchar(8000)


	End
Else
	select @sql= 'The table '+@table_server + ' does not exist'

return @sql

END*/




