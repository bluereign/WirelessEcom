CREATE TABLE [salesorder].[ShipMethodPromos] (
    [PromoId]          INT          IDENTITY (1, 1) NOT NULL,
    [CarrierId]        INT          NULL,
    [ShipMethodId]     INT          NULL,
    [Name]             VARCHAR (20) NULL,
    [DefaultFixedCost] MONEY        NULL,
    [StartDt]          DATETIME     NULL,
    [EndDt]            DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([PromoId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'ShipMethodPromos', @level2type = N'COLUMN', @level2name = N'PromoId';

