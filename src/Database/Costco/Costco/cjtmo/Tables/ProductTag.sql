CREATE TABLE [cjtmo].[ProductTag] (
    [ProductGuid] UNIQUEIDENTIFIER NOT NULL,
    [Tag]         NVARCHAR (100)   NOT NULL,
    [InsertDate]  DATETIME         CONSTRAINT [CJTMO_ProductTag_CreateDate] DEFAULT (getdate()) NOT NULL
);

