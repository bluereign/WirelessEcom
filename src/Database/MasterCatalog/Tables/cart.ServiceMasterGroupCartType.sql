CREATE TABLE [cart].[ServiceMasterGroupCartType]
(
[CartTypeId] [int] NULL,
[ServiceMasterGroupGuid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [catalog].[ServiceMasterGroup] + [cart].[CartType]', 'SCHEMA', N'cart', 'TABLE', N'ServiceMasterGroupCartType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [cart].[CartType]', 'SCHEMA', N'cart', 'TABLE', N'ServiceMasterGroupCartType', 'COLUMN', N'CartTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[ServiceMasterGroup]', 'SCHEMA', N'cart', 'TABLE', N'ServiceMasterGroupCartType', 'COLUMN', N'ServiceMasterGroupGuid'
GO
