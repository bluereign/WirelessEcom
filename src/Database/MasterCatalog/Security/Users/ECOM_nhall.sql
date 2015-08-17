IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ECOM\nhall')
CREATE LOGIN [ECOM\nhall] FROM WINDOWS
GO
CREATE USER [ECOM\nhall] FOR LOGIN [ECOM\nhall]
GO
