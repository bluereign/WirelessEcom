CREATE TABLE [salesorder].[ShipMethodPromos] (
    [PromoId]          INT          IDENTITY (1, 1) NOT NULL,
    [CarrierId]        INT          NULL,
    [ShipMethodId]     INT          NULL,
    [Name]             VARCHAR (20) NULL,
    [DefaultFixedCost] MONEY        NULL,
    [StartDt]          DATETIME     NULL,
    [EndDt]            DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([PromoId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

