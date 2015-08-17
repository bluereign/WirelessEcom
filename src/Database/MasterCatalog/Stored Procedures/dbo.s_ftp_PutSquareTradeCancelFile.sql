SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[s_ftp_PutSquareTradeCancelFile]
@FTPFileName	varchar(128) ,
@SourcePath	varchar(128) ,
@SourceFile	varchar(128) ,
@workdir	varchar(128)

as
/*
exec s_ftp_PutFile 	
		@FTPServer = 'myftpsite' ,
		@FTPUser = 'username' ,
		@FTPPWD = 'password' ,
		@FTPPath = '/dir1/' ,
		@FTPFileName = 'test2.txt' ,
		@SourcePath = 'c:\vss\mywebsite\' ,
		@SourceFile = 'MyFileName.html' ,
		
		@workdir = 'c:\temp\'
*/

declare	@cmd varchar(1000)
	

	
	SELECT @cmd = 'ren ' + @SourcePath + @SourceFile + ' ' + @FtpFileName
	exec master..xp_cmdshell @cmd	
	select  @cmd = 'cd "program files (x86)"\"NcFTP Software"'
	exec master..xp_cmdshell @cmd
	select	@cmd = 'ncftpput -f C:\Restore\login.txt incoming/cancels/' + ' ' + @SourcePath + @FTPFileName
	exec master..xp_cmdshell @cmd
	select	@cmd = 'quit'
	exec master..xp_cmdshell @cmd
	


GO
