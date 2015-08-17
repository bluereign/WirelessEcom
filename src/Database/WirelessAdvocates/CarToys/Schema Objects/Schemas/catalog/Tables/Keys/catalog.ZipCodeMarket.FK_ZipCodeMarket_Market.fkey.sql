ALTER TABLE [catalog].[ZipCodeMarket]
    ADD CONSTRAINT [FK_ZipCodeMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

