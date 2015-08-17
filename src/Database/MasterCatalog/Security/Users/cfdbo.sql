IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'cfdbo')
CREATE LOGIN [cfdbo] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [cfdbo] FOR LOGIN [cfdbo]
GO
