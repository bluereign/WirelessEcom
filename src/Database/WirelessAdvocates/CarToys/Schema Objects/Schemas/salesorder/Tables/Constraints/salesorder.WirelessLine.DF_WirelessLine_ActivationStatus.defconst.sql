ALTER TABLE [salesorder].[WirelessLine]
    ADD CONSTRAINT [DF_WirelessLine_ActivationStatus] DEFAULT ((0)) FOR [ActivationStatus];

