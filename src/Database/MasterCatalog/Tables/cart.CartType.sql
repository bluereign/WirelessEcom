CREATE TABLE [cart].[CartType]
(
[CartTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentCartTypeId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [cart].[CartType] ADD CONSTRAINT [PK__CartType__FFD3AA6F717E7904] PRIMARY KEY CLUSTERED  ([CartTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cart type indicates New Activation versus Upgrade versus Add-A-Line, etc.', 'SCHEMA', N'cart', 'TABLE', N'CartType', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'cart', 'TABLE', N'CartType', 'COLUMN', N'CartTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'cart', 'TABLE', N'CartType', 'COLUMN', N'CartTypeId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'cart', 'TABLE', N'CartType', 'COLUMN', N'ParentCartTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub-key for different scenarios under the main cart type.', 'SCHEMA', N'cart', 'TABLE', N'CartType', 'COLUMN', N'ParentCartTypeId'
GO
