CREATE TABLE [salesorder].[ShipMethod] (
    [ShipMethodId]      INT           IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (20)  NULL,
    [DisplayName]       VARCHAR (150) NULL,
    [IsActive]          BIT           CONSTRAINT [DF_ShipMethod_IsActive] DEFAULT ((0)) NOT NULL,
    [DefaultFixedCost]  MONEY         NULL,
    [GersShipMethodId]  INT           DEFAULT ((0)) NOT NULL,
    [CarrierId]         NVARCHAR (30) DEFAULT ('0,42,109,128,299') NOT NULL,
    [PromoPrice]        MONEY         NULL,
    [PromoDisplayName]  VARCHAR (150) NULL,
    [PromoCarrierId]    VARCHAR (150) NULL,
    [IsApoAfoAvailable] BIT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ShipMethods] PRIMARY KEY CLUSTERED ([ShipMethodId] ASC) WITH (FILLFACTOR = 90)
);

