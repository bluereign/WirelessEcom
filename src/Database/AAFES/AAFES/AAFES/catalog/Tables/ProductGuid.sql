CREATE TABLE [catalog].[ProductGuid] (
    [ProductGuid]   UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ProductTypeId] TINYINT          NOT NULL,
    CONSTRAINT [PK_ProductGuid] PRIMARY KEY CLUSTERED ([ProductGuid] ASC),
    CONSTRAINT [FK_ProductGuidType_ProductTypes] FOREIGN KEY ([ProductTypeId]) REFERENCES [catalog].[ProductType] ([ProductTypeId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ProdGuID_index]
    ON [catalog].[ProductGuid]([ProductTypeId] ASC, [ProductGuid] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductGuidType]
    ON [catalog].[ProductGuid]([ProductGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [catalog].[ProductType] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductGuid', @level2type = N'COLUMN', @level2name = N'ProductTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductGuid', @level2type = N'COLUMN', @level2name = N'ProductTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductGuid', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductGuid', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates type of product (Accessory, Device, etc.)', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ProductGuid';

