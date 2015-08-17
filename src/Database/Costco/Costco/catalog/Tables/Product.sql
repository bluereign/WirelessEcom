CREATE TABLE [catalog].[Product] (
    [ProductId]   INT              IDENTITY (1, 1) NOT NULL,
    [ProductGuid] UNIQUEIDENTIFIER NULL,
    [GersSku]     NVARCHAR (9)     NULL,
    [Active]      BIT              CONSTRAINT [DF_Product_Active] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([ProductId] ASC),
    CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]),
    CONSTRAINT [FK_Product_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
);


GO
CREATE NONCLUSTERED INDEX [IX_ProductGuid_Active_ProductId_GersSku]
    ON [catalog].[Product]([ProductGuid] ASC, [Active] ASC, [ProductId] ASC, [GersSku] ASC);


GO
CREATE STATISTICS [_dta_stat_1624444911_3_2_4]
    ON [catalog].[Product]([GersSku], [ProductGuid], [Active]);


GO
CREATE STATISTICS [_dta_stat_1624444911_3_4]
    ON [catalog].[Product]([GersSku], [Active]);


GO
CREATE STATISTICS [_dta_stat_1624444911_4]
    ON [catalog].[Product]([Active]);

