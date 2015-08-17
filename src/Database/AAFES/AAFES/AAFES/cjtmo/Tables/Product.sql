CREATE TABLE [cjtmo].[Product] (
    [ProductId]   INT              NOT NULL,
    [ProductGuid] UNIQUEIDENTIFIER NOT NULL,
    [GersSku]     NVARCHAR (9)     NOT NULL,
    [Active]      BIT              DEFAULT ((0)) NOT NULL,
    [InsertDate]  DATETIME         CONSTRAINT [DF_Product_CreateDate] DEFAULT (getdate()) NOT NULL
);

