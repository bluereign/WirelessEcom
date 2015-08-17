-- Name: sp_DeleteBackupsFromDBDirectory
-- Description: This procedure cleans up files in a database directory. It is called by the stored procedure sp_CleanUpServers, once for each database

CREATE PROCEDURE sp_DeleteBackupsFromDBDirectory
	@directory varchar(45)
as 

-- The first table will contain the whole directory, as whole lines
create table #tempdirectory (filepath varchar(150))
-- The second table will contain all files in the directory
create table #tempdirectory2 (filedate datetime, filename varchar(50))
-- The third table will contain only files in the directory that are older than two days old
create table #tempdirectory3 (filedate datetime, filename varchar(50))

declare @filecount int
declare @sqlstring varchar(150)
declare @filename varchar(50)
declare @directoryroot varchar(100)

-- Look for CarToys database backups
--insert into #tempdirectory exec master.dbo.xp_cmdshell 'dir D:Data\MSSQL\Backup\CarToys\CarToys_db*.*'
set @sqlstring = 'insert into #tempdirectory exec master.dbo.xp_cmdshell ''dir ' + @directory + '*.*'''
--select (@sqlstring)
exec(@sqlstring)
delete from #tempdirectory where filepath is null
delete from #tempdirectory where filepath like ' %'

--select * from #tempdirectory

insert into #tempdirectory2 (filedate, filename) 
select cast(left(filepath, 10) as datetime), right(filepath, charIndex(' ', reverse(filepath))-1) from #tempdirectory where filepath not like '%Diff%'

--select * from #tempdirectory2

set @filecount = (select count(*) from #tempdirectory2)
set @filecount = @filecount - 3
set @sqlstring = 'insert into #tempdirectory3 select * from #tempdirectory2 where getDate() - filedate > 2 order by filedate asc'
exec(@sqlstring)

set @sqlstring = ''
set @directoryroot = left(@directory, len(@directory) - charIndex('\', reverse(@directory)))

DECLARE dir_cursor CURSOR FOR	SELECT filename FROM #tempdirectory3
OPEN dir_cursor

FETCH NEXT FROM dir_cursor INTO @filename

WHILE @@FETCH_STATUS = 0 BEGIN
		set @sqlstring = 'exec master.dbo.xp_cmdshell ''del ' + @directoryroot + '\' + @filename + ''''
	--select @filename
	exec(@sqlstring)

	-- Get the next file.
	FETCH NEXT FROM dir_cursor INTO @filename
END

CLOSE dir_cursor
DEALLOCATE dir_cursor

drop table #tempdirectory
drop table #tempdirectory2
drop table #tempdirectory3