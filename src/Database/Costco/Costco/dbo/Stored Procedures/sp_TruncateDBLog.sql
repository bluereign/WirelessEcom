CREATE PROCEDURE sp_TruncateDBLog
	@dbname varchar(45)
AS

declare @sqlstring varchar(1000)
declare @backupname varchar(100)

-- Backup the database
set @backupname = @dbname + '_db_' + cast(datepart(yyyy, getDate())  as varchar(4)) + cast(datepart(mm,getDate()) as varchar(2)) 
set @backupname = @backupname + cast(datepart(dd,getDate()) as varchar(2)) + cast(datepart(ms,getDate()) as varchar(3)) + '.bak'

set @sqlstring = 'backup database ' + @dbname  + ' to DISK = ''D:\Data\MSSQL\Backup\' + @dbname + '\' + @backupname + ''''
	--select (@sqlstring)
--exec (@sqlstring)

-- Shut off the ColdFusion appllication server
exec master.dbo.xp_cmdshell 'net stop ''Cold Fusion Application Server'''


-- detach the database
set @sqlstring = 'sp_detach_db @dbname = ''' + @dbname + ''', @skipchecks = true'
select (@sqlstring)
exec (@sqlstring)


-- rename the database log file
	--Delete/rename the disk log file.

-- re-attach the database
set @sqlstring = 'sp_attach_single_file_db @dbname = ''' + @dbname + ''', @physname = ''D:\Data\MSSQL\Data\' +@dbname + '.mdf'''

select (@sqlstring)
exec (@sqlstring)
	-- sp_attach_single_file_db @dbname, [filename]
	--where [filename] is the name of the physical data file (.mdf).


-- Shut off the ColdFusion appllication server
exec master.dbo.xp_cmdshell 'net start ''Cold Fusion Application Server'''