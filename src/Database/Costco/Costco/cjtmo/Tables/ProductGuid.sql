CREATE TABLE [cjtmo].[ProductGuid] (
    [ProductGuid]   UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ProductTypeId] TINYINT          NOT NULL,
    [InsertDate]    DATETIME         CONSTRAINT [CJTMO_ProductGuid_CreateDate] DEFAULT (getdate()) NOT NULL
);

