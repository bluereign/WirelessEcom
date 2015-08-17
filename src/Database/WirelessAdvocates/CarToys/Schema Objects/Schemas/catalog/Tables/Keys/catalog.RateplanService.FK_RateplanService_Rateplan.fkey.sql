ALTER TABLE [catalog].[RateplanService]
    ADD CONSTRAINT [FK_RateplanService_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

