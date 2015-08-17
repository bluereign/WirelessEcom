/*-- Name: fn_Generate_SQL_Script
-- Description: This user-defined function generates the SQL script to generate a table.
--	It takes 3 input variables: 1) the table name to be copied, 2) the new table name that the return DDL will create, and 3) the name of the identity column of the table to be created. All three variables are varchars.
--	Sample Usage: select @ddl = dbo.fn_Generate_SQL_Script ('Users', 'Users', 'User_ID')
--

CREATE FUNCTION fn_Generate_SQL_Script (
	@tableName varchar(100),
	@newTableName varchar(100),
	@identity varchar(50) = null
)  

RETURNS varchar(8000) AS  
BEGIN 

If exists (Select * from Information_Schema.COLUMNS where Table_Name=@tableName)
Begin
	declare @sql varchar(8000)
	declare @table varchar(100)
	declare @cols table (datatype varchar(50))
	insert into @cols values('bit')
	insert into @cols values('binary')
	insert into @cols values('bigint')
	insert into @cols values('int')
	insert into @cols values('float')
	insert into @cols values('datetime')
	insert into @cols values('text')
	insert into @cols values('image')
	insert into @cols values('uniqueidentifier')
	insert into @cols values('smalldatetime')
	insert into @cols values('tinyint')
	insert into @cols values('smallint')
	insert into @cols values('sql_variant')

	set @sql=''
	Select @sql=@sql
		+case when charindex('(',@sql,1) <= 0 then '(' else '' end + Column_Name + ' ' + Data_Type 
		+case when Data_Type in ( Select datatype from @cols) then '' else '(' end
		+case when data_type in ('real','money','decimal','numeric') then cast(isnull(numeric_precision,'') as varchar)
		+','
		+case when data_type in ('real','money','decimal','numeric') then cast(isnull(Numeric_Scale,'') as varchar)
			end when data_type in ('char','nvarchar','varchar','nchar') then cast(isnull(Character_Maximum_Length,'') as varchar) else '' end
		+case when Data_Type in (Select datatype from @cols)then '' else ')' end
		+case when Column_Name = @identity then ' primary key identity(1,1) ' else '' end
		+case when Is_Nullable='No' and Column_Name <> @identity  then ' Null' else ' Not null' end
		+ ', '
	from Information_Schema.COLUMNS 
	where Table_Name=@tableName

	select @table= 'Create table ' + @newTableName
	select @sql=@table + substring(@sql,1,len(@sql)-1) +' )'
	End
Else
	Select @sql = 'The table '+@tableName + ' does not exist'

return @sql

END*/



