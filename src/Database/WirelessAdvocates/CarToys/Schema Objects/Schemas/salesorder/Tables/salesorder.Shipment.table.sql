CREATE TABLE [salesorder].[Shipment] (
    [ShipmentId]     INT          IDENTITY (1, 1) NOT NULL,
    [ShipMethodId]   INT          NULL,
    [TrackingNumber] VARCHAR (18) NULL,
    [DeliveryStatus] VARCHAR (10) NULL
);

