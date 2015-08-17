ALTER TABLE [catalog].[Market]
    ADD CONSTRAINT [DF_CarrierMarket_MarketGuid] DEFAULT (newid()) FOR [MarketGuid];

