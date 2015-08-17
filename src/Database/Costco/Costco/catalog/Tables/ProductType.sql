CREATE TABLE [catalog].[ProductType] (
    [ProductTypeId] TINYINT       NOT NULL,
    [ProductType]   NVARCHAR (12) NOT NULL,
    CONSTRAINT [PK_ProductTypes] PRIMARY KEY CLUSTERED ([ProductTypeId] ASC)
);

