CREATE TABLE [cataloglastweek].[ProductType]
(
[ProductTypeId] [tinyint] NOT NULL,
[ProductType] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[ProductType] ADD CONSTRAINT [PK_ProductTypes] PRIMARY KEY CLUSTERED  ([ProductTypeId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Legend of ProductType values seen in the [catalog].[ProductGuid] table', 'SCHEMA', N'cataloglastweek', 'TABLE', N'ProductType', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'ProductType', 'COLUMN', N'ProductTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'cataloglastweek', 'TABLE', N'ProductType', 'COLUMN', N'ProductTypeId'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'cataloglastweek', 'TABLE', N'ProductType', 'COLUMN', N'ProductTypeId'
GO
