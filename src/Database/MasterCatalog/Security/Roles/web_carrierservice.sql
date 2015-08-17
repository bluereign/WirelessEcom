CREATE ROLE [web_carrierservice]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'web_carrierservice', N'ECOM\nhall'
GO

EXEC sp_addrolemember N'web_carrierservice', N'omtsql'
GO
