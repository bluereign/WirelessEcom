CREATE TABLE [salesorder].[Shipment] (
    [ShipmentId]     INT          IDENTITY (1, 1) NOT NULL,
    [ShipMethodId]   INT          NULL,
    [TrackingNumber] VARCHAR (18) NULL,
    [DeliveryStatus] VARCHAR (10) NULL,
    CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED ([ShipmentId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Shipment_ShipMethod] FOREIGN KEY ([ShipMethodId]) REFERENCES [salesorder].[ShipMethod] ([ShipMethodId])
);

