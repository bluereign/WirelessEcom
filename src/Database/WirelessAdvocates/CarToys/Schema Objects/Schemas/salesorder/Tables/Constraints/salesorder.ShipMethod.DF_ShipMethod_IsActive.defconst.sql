ALTER TABLE [salesorder].[ShipMethod]
    ADD CONSTRAINT [DF_ShipMethod_IsActive] DEFAULT ((0)) FOR [IsActive];

