ALTER TABLE [catalog].[RateplanDevice]
    ADD CONSTRAINT [FK_RateplanDevice_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

