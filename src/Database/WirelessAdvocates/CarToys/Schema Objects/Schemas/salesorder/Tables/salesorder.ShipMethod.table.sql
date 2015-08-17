CREATE TABLE [salesorder].[ShipMethod] (
    [ShipMethodId]     INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (20)  NULL,
    [DisplayName]      VARCHAR (150) NULL,
    [IsActive]         BIT           NOT NULL,
    [DefaultFixedCost] MONEY         NULL
);

