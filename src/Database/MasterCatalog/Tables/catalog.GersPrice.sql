CREATE TABLE [catalog].[GersPrice]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceGroupCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [money] NOT NULL,
[StartDate] [date] NOT NULL,
[EndDate] [date] NOT NULL,
[Comment] [nvarchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[GersPrice] ADD CONSTRAINT [FK_GersPrice_GersPriceGroup] FOREIGN KEY ([PriceGroupCode]) REFERENCES [catalog].[GersPriceGroup] ([PriceGroupCode])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prices imported from GERS.', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'COG = Cost of Goods, ECA = Ecomm Add-A-Line Activation, ECN = Ecomm New 2yr Activation, ECP = Ecomm Base Retail, ECU = Ecomm Upgrade Activation', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the price will expire.', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Links to [catalog].[Product] or [catalog].[GersItm]', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'Price'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Price of item.', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'Price'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'PriceGroupCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to [catalog].[GersPriceGroup] table', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'PriceGroupCode'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'StartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the price will begin appearing on the site.', 'SCHEMA', N'catalog', 'TABLE', N'GersPrice', 'COLUMN', N'StartDate'
GO
