CREATE TABLE [catalog].[Product] (
    [ProductId]   INT              IDENTITY (1, 1) NOT NULL,
    [ProductGuid] UNIQUEIDENTIFIER NULL,
    [GersSku]     NVARCHAR (9)     NULL,
    [Active]      BIT              CONSTRAINT [DF_Product_Active] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]),
    CONSTRAINT [FK_Product_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductGuid_Active_ProductId_GersSku]
    ON [catalog].[Product]([ProductGuid] ASC, [Active] ASC, [ProductId] ASC, [GersSku] ASC) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [_dta_stat_1624444911_3_2_4]
    ON [catalog].[Product]([GersSku], [ProductGuid], [Active]);


GO
CREATE STATISTICS [_dta_stat_1624444911_3_4]
    ON [catalog].[Product]([GersSku], [Active]);


GO
CREATE STATISTICS [_dta_stat_1624444911_4]
    ON [catalog].[Product]([Active]);


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'Active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether or not the product is actively listed on the site. (1) Active and (0) Inactive.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'Active';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'Active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to GersItm table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'GersSku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to ProductGuid table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product', @level2type = N'COLUMN', @level2name = N'ProductId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of all products, regardless of it being device, accessory, tablet, etc. with its GERS Sku. Also includes if the product should be actively available on the site or not.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Product';

