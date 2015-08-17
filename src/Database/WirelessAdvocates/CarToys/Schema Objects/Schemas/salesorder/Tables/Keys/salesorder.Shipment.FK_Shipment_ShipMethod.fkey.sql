ALTER TABLE [salesorder].[Shipment]
    ADD CONSTRAINT [FK_Shipment_ShipMethod] FOREIGN KEY ([ShipMethodId]) REFERENCES [salesorder].[ShipMethod] ([ShipMethodId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

