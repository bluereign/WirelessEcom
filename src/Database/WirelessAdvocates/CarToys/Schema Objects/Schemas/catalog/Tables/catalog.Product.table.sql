CREATE TABLE [catalog].[Product] (
    [ProductId]   INT              IDENTITY (1, 1) NOT NULL,
    [ProductGuid] UNIQUEIDENTIFIER NULL,
    [GersSku]     NVARCHAR (9)     NULL,
    [Active]      BIT              NOT NULL
);

