CREATE ROLE [wareports]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'wareports', N'ECOM\nhall'
GO

EXEC sp_addrolemember N'wareports', N'omtsql'
GO
