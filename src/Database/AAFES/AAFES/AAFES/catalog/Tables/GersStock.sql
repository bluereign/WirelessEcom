CREATE TABLE [catalog].[GersStock] (
    [GersSku]       NVARCHAR (9)  NOT NULL,
    [OutletId]      NVARCHAR (10) NOT NULL,
    [OutletCode]    NVARCHAR (3)  NOT NULL,
    [StoreCode]     NVARCHAR (2)  NOT NULL,
    [LocationCode]  NVARCHAR (6)  NOT NULL,
    [Qty]           INT           NOT NULL,
    [Cost]          MONEY         NOT NULL,
    [FiflDate]      DATE          NOT NULL,
    [IMEI]          VARCHAR (15)  NULL,
    [SIM]           VARCHAR (20)  NULL,
    [OrderDetailId] INT           NULL,
    [BlockId]       INT           NULL,
    CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED ([OutletId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_GS_CascadeId] FOREIGN KEY ([BlockId]) REFERENCES [ALLOCATION].[Block] ([BlockId])
);


GO
CREATE NONCLUSTERED INDEX [NCL_catalog_GersStock_GersSku]
    ON [catalog].[GersStock]([GersSku] ASC)
    INCLUDE([BlockId]) WITH (DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [<GersStockSku, sysname,>]
    ON [catalog].[GersStock]([OrderDetailId] ASC)
    INCLUDE([GersSku]) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [_dta_stat_563585146_11_9]
    ON [catalog].[GersStock]([OrderDetailId], [IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_1]
    ON [catalog].[GersStock]([OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_3_1_2]
    ON [catalog].[GersStock]([OrderDetailId], [OutletCode], [GersSku], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_1_11_8]
    ON [catalog].[GersStock]([GersSku], [OrderDetailId], [FiflDate]);


GO
CREATE STATISTICS [_dta_stat_563585146_11_2_1]
    ON [catalog].[GersStock]([OrderDetailId], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_2_1]
    ON [catalog].[GersStock]([OutletCode], [OutletId], [GersSku]);


GO
CREATE STATISTICS [_dta_stat_563585146_9]
    ON [catalog].[GersStock]([IMEI]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_11_2]
    ON [catalog].[GersStock]([OutletCode], [OrderDetailId], [OutletId]);


GO
CREATE STATISTICS [_dta_stat_563585146_2_3]
    ON [catalog].[GersStock]([OutletId], [OutletCode]);


GO
CREATE STATISTICS [_dta_stat_563585146_3_1_11_8]
    ON [catalog].[GersStock]([OutletCode], [GersSku], [OrderDetailId], [FiflDate]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'
Links to the [salesorder].[OrderDetail] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'21-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'
Links to the [salesorder].[WirelessLine] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'SIM';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'21-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'SIM';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to the [salesorder].[WirelessLine] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'IMEI';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'21-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'IMEI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'OutletId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'OutletId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Product] and [catalog].[GersItm] to name a few', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'GersSku';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock', @level2type = N'COLUMN', @level2name = N'GersSku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What is in stock on the site. Each device that is in stock is indicated by a unique OutletId. If the device or accessory is not in this table, it is considered out of stock and unavailable. In PROD, this table is always populated through a GERS job. On TEST, it is automatically populated by a separate job that creates fake inventory for testing purposes.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersStock';

