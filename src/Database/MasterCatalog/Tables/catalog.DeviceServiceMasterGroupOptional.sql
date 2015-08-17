CREATE TABLE [catalog].[DeviceServiceMasterGroupOptional]
(
[DeviceGuid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[DeviceServiceMasterGroupOptional] ADD CONSTRAINT [PK_DeviceServiceMasterGroupOptional] PRIMARY KEY CLUSTERED  ([DeviceGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. TABLES CONNECTED AND PURPOSE IS UNKNOWN.', 'SCHEMA', N'catalog', 'TABLE', N'DeviceServiceMasterGroupOptional', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'DeviceServiceMasterGroupOptional', 'COLUMN', N'DeviceGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key, also FK, links to [catalog].[Device]', 'SCHEMA', N'catalog', 'TABLE', N'DeviceServiceMasterGroupOptional', 'COLUMN', N'DeviceGuid'
GO
