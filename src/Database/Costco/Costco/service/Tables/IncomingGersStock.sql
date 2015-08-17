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
    CONSTRAINT [PK_GersStock] PRIMARY KEY CLUSTERED ([OutletId] ASC)
);

