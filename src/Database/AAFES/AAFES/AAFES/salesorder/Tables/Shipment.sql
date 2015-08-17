CREATE TABLE [salesorder].[Shipment] (
    [ShipmentId]     INT          IDENTITY (1, 1) NOT NULL,
    [ShipMethodId]   INT          NULL,
    [TrackingNumber] VARCHAR (18) NULL,
    [DeliveryStatus] VARCHAR (10) NULL,
    CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED ([ShipmentId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_Shipment_ShipMethod] FOREIGN KEY ([ShipMethodId]) REFERENCES [salesorder].[ShipMethod] ([ShipMethodId])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to ShipMethod table', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Shipment', @level2type = N'COLUMN', @level2name = N'ShipMethodId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Shipment', @level2type = N'COLUMN', @level2name = N'ShipmentId';

