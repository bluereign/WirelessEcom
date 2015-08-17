-- Name: sp_DeleteFileIfExists
-- Description: This procedure checks for a specific file, and deletes it if it exists.

CREATE PROCEDURE sp_DeleteFileIfExists
	@directory varchar(45), @targetfile varchar(50)
as 

-- The second table will contain only the target file
create table #tempdirectory (filepath varchar(150))

declare @filecount int
declare @sqlstring varchar(150)
declare @filename varchar(50)


-- Look for CarToys database backups
--insert into #tempdirectory exec master.dbo.xp_cmdshell 'dir D:Data\MSSQL\Backup\CarToys\CarToys_db*.*'
set @sqlstring = 'insert into #tempdirectory exec master.dbo.xp_cmdshell ''dir ' + @directory + ''''
select (@sqlstring)
exec(@sqlstring)
delete from #tempdirectory where filepath is null
delete from #tempdirectory where filepath like ' %'
delete from #tempdirectory where filepath = 'File Not Found'

select * from #tempdirectory

set @filecount = (select count(*) from #tempdirectory)
--	select (@filecount)

if (@filecount > 0) begin 
	set @sqlstring = 'exec master.dbo.xp_cmdshell ''del ' + @directory + @targetfile + ''''
	exec(@sqlstring)
end

drop table #tempdirectory