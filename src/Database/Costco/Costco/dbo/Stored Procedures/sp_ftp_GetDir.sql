Create procedure sp_ftp_GetDir
	@FTPServer	varchar(128) ,
	@FTPUser	varchar(128) ,
	@FTPPWD	varchar(128) ,
	@FTPPath	varchar(128) ,
	@workdir	varchar(128)
as
/*
exec s_ftp 'myftpsite', 'username', 'password', '/dir1/', 'c:\temp\'
*/

declare	@cmd varchar(1000)
declare @workfilename varchar(128)
	
	select @workfilename = 'ftpcmd.txt'
	
	-- deal with special characters for echo commands
	select @FTPServer = replace(replace(replace(@FTPServer, '|', '^|'),'<','^<'),'>','^>')
	select @FTPUser = replace(replace(replace(@FTPUser, '|', '^|'),'<','^<'),'>','^>')
	select @FTPPWD = replace(replace(replace(@FTPPWD, '|', '^|'),'<','^<'),'>','^>')
	select @FTPPath = replace(replace(replace(@FTPPath, '|', '^|'),'<','^<'),'>','^>')
	
	select	@cmd = 'echo '					+ 'open ' + @FTPServer
			+ ' > ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ @FTPUser
			+ '>> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ @FTPPWD
			+ '>> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ 'dir ' + @FTPPath
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	select	@cmd = 'echo '					+ 'quit'
			+ ' >> ' + @workdir + @workfilename
	exec master..xp_cmdshell @cmd
	
	select @cmd = 'ftp -s:' + @workdir + @workfilename
	
	create table #a (id int identity(1,1), s varchar(1000))
	insert #a
	exec master..xp_cmdshell @cmd
	
	select id, s from #a
	drop table #a