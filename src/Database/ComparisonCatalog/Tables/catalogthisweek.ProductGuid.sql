CREATE TABLE [catalogthisweek].[ProductGuid]
(
[ProductGuid] [uniqueidentifier] NOT NULL ROWGUIDCOL,
[ProductTypeId] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[ProductGuid] ADD CONSTRAINT [PK_ProductGuid] PRIMARY KEY CLUSTERED  ([ProductGuid]) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[ProductGuid] ADD CONSTRAINT [FK_ProductGuidType_ProductTypes] FOREIGN KEY ([ProductTypeId]) REFERENCES [catalogthisweek].[ProductType] ([ProductTypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates type of product (Accessory, Device, etc.)', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ProductGuid', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ProductGuid', 'COLUMN', N'ProductGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ProductGuid', 'COLUMN', N'ProductGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ProductGuid', 'COLUMN', N'ProductTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to [catalog].[ProductType] table', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ProductGuid', 'COLUMN', N'ProductTypeId'
GO
