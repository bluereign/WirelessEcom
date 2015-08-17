CREATE TABLE [cataloglastweek].[Product]
(
[ProductId] [int] NOT NULL IDENTITY(1, 1),
[ProductGuid] [uniqueidentifier] NULL,
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Product_Active] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[Product] ADD CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED  ([ProductId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[Product] WITH NOCHECK ADD CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [cataloglastweek].[GersItm] ([GersSku])
GO
ALTER TABLE [cataloglastweek].[Product] WITH NOCHECK ADD CONSTRAINT [FK_Product_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [cataloglastweek].[ProductGuid] ([ProductGuid])
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of all products, regardless of it being device, accessory, tablet, etc. with its GERS Sku. Also includes if the product should be actively available on the site or not.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Whether or not the product is actively listed on the site. (1) Active and (0) Inactive.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to GersItm table', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to ProductGuid table', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'ProductGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Product', 'COLUMN', N'ProductId'
GO
