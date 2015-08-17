IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'WALLC\smorrow')
CREATE LOGIN [WALLC\smorrow] FROM WINDOWS
GO
CREATE USER [WALLC\smorrow] FOR LOGIN [WALLC\smorrow]
GO
