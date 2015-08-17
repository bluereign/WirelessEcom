IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'managefilter')
CREATE LOGIN [managefilter] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [managefilter] FOR LOGIN [managefilter]
GO
