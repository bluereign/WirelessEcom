CREATE TABLE [service].[IncomingGersStock] (
    [GersSku]      NVARCHAR (9)  NOT NULL,
    [OutletId]     NVARCHAR (10) NOT NULL,
    [OutletCode]   NVARCHAR (3)  NOT NULL,
    [StoreCode]    NVARCHAR (2)  NOT NULL,
    [LocationCode] NVARCHAR (6)  NOT NULL,
    [Qty]          INT           NOT NULL,
    [Cost]         MONEY         NOT NULL,
    [FiflDate]     DATE          NOT NULL,
    [IMEI]         VARCHAR (15)  NULL,
    [SIM]          VARCHAR (20)  NULL,
    CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED ([OutletId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'IncomingGersStock', @level2type = N'COLUMN', @level2name = N'OutletId';

