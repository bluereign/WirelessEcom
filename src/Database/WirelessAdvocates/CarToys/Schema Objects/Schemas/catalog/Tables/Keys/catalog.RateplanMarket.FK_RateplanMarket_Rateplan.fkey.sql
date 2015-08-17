ALTER TABLE [catalog].[RateplanMarket]
    ADD CONSTRAINT [FK_RateplanMarket_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

