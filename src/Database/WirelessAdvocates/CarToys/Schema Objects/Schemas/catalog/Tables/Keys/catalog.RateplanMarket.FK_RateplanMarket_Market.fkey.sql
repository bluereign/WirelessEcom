ALTER TABLE [catalog].[RateplanMarket]
    ADD CONSTRAINT [FK_RateplanMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

