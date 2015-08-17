CREATE TABLE [catalog].[AccessoryForDevice]
(
[DeviceGuid] [uniqueidentifier] NOT NULL,
[AccessoryGuid] [uniqueidentifier] NOT NULL,
[Ordinal] [int] NOT NULL CONSTRAINT [DF_OrderOne] DEFAULT ('1'),
[CreateDate] [datetime] NULL CONSTRAINT [DF_AccessoryForDevice_CreateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [catalog].[Accessory] + [catalog].[Device] KITS SHOULD BE IN THIS TABLE.', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', 'COLUMN', N'AccessoryGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[Device] or [catalog].[Product] table', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', 'COLUMN', N'AccessoryGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', 'COLUMN', N'DeviceGuid'
GO
EXEC sp_addextendedproperty N'ModifiedDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', 'COLUMN', N'DeviceGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[Device] or [catalog].[Product] table', 'SCHEMA', N'catalog', 'TABLE', N'AccessoryForDevice', 'COLUMN', N'DeviceGuid'
GO
