CREATE ROLE [web_ecomsite]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'web_ecomsite', N'ECOM\nhall'
GO

EXEC sp_addrolemember N'web_ecomsite', N'omtsql'
GO
