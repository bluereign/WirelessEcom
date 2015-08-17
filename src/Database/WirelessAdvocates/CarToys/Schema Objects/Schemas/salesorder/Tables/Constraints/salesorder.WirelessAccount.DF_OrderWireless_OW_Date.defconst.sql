ALTER TABLE [salesorder].[WirelessAccount]
    ADD CONSTRAINT [DF_OrderWireless_OW_Date] DEFAULT (getdate()) FOR [CarrierOrderDate];

