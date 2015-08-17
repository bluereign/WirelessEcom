ALTER TABLE [salesorder].[Order]
    ADD CONSTRAINT [DF_Orders_SentToGERS] DEFAULT ((0)) FOR [GERSStatus];

