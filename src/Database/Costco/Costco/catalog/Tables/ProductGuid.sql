CREATE TABLE [catalog].[ProductGuid] (
    [ProductGuid]   UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ProductTypeId] TINYINT          NOT NULL,
    CONSTRAINT [FK_ProductGuidType_ProductTypes] FOREIGN KEY ([ProductTypeId]) REFERENCES [catalog].[ProductType] ([ProductTypeId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductGuidType]
    ON [catalog].[ProductGuid]([ProductGuid] ASC);

