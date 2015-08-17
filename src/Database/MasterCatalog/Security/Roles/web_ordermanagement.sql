CREATE ROLE [web_ordermanagement]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'web_ordermanagement', N'ECOM\nhall'
GO

EXEC sp_addrolemember N'web_ordermanagement', N'omtsql'
GO
