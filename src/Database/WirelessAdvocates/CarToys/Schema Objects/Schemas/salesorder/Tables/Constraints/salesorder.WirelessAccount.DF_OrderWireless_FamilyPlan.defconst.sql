ALTER TABLE [salesorder].[WirelessAccount]
    ADD CONSTRAINT [DF_OrderWireless_FamilyPlan] DEFAULT ((0)) FOR [FamilyPlan];

