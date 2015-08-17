IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ECOM\sqlservice')
CREATE LOGIN [ECOM\sqlservice] FROM WINDOWS
GO
CREATE USER [ECOM\sqlservice] FOR LOGIN [ECOM\sqlservice]
GO
