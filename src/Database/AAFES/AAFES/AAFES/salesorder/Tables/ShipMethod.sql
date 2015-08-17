CREATE TABLE [salesorder].[ShipMethod] (
    [ShipMethodId]      INT           IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (20)  NULL,
    [DisplayName]       VARCHAR (150) NULL,
    [IsActive]          BIT           CONSTRAINT [DF_ShipMethod_IsActive] DEFAULT ((0)) NOT NULL,
    [DefaultFixedCost]  MONEY         NULL,
    [GersShipMethodId]  INT           DEFAULT ((0)) NOT NULL,
    [CarrierId]         NVARCHAR (30) CONSTRAINT [DF__ShipMetho__Carri__33A4CEDD] DEFAULT ('0,42,109,128,299') NOT NULL,
    [PromoPrice]        MONEY         NULL,
    [PromoDisplayName]  VARCHAR (150) NULL,
    [PromoCarrierId]    VARCHAR (150) NULL,
    [IsApoAfoAvailable] BIT           CONSTRAINT [DF__ShipMetho__IsApo__5B552F89] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ShipMethods] PRIMARY KEY CLUSTERED ([ShipMethodId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'ShipMethod', @level2type = N'COLUMN', @level2name = N'ShipMethodId';

