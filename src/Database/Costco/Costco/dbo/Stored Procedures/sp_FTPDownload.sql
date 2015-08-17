create procedure sp_FTPDownload (@ftpid int=1)
as
/*
This procedure connects by FTP to Point.com and download the flat files
*/

declare @ftp varchar(500), 
	@batchfile varchar(300),
	@bcp varchar(300),
	@ftpserver varchar(100), 
	@ftplogin varchar(30), 
	@ftppass varchar(30),
	@deletefiles bit,
	@localfolder varchar(200), 
	@ftpfolder varchar(200)

select	@ftpserver=ftpserver, 
	@ftplogin =ftplogin, 
	@ftppass =ftppass,
	@localfolder =localfolder, 
	@ftpfolder = ftpfolder,
	@deletefiles = deletefiles
from FTPConfig where ftpid = @ftpid

	--create text commands for FTP batch file 
set @batchfile = @ftplogin + '
' + @ftppass + '
lcd "'+@localfolder+'"'+ '
cd "'+ @ftpfolder + '"
bin 
prompt
prompt
mget *
'
if @deletefiles =1
	set @batchfile =@batchfile +'mdelete *
'

set @batchfile =@batchfile +'bye 
'
--clean up temporary table 
truncate table batch 
--insert batch text in temp table
insert into batch values(@batchfile)
--select * from batch
	
--export content to .bat file
SET QUOTED_IDENTIFIER  ON
set @bcp = 'bcp Cartoys_Wireless.dbo.Batch out "c:\wirelessdownload.bat" -c -T '
exec master.dbo.xp_cmdshell @bcp
SET QUOTED_IDENTIFIER  ON
	
--upload file to ftp site
set @ftp= 'ftp -i -s:"c:\wirelessdownload.bat" '+@ftpserver
exec master.dbo.xp_cmdshell @ftp

/*
select * from FTPConfig
create table FTPConfig (
	FTPID int identity(1,1) primary key,
	ftpserver varchar(100), 
	ftplogin varchar(30), 
	ftppass varchar(30),
	localfolder varchar(200), 
	ftpfolder varchar(200)
)
exec sp_FTPDownload
exec sp_bulkInsert
exec sp_importdb
*/