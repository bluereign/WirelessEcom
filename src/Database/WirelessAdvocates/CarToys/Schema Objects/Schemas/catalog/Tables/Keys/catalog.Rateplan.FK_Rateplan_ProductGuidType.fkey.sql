ALTER TABLE [catalog].[Rateplan]
    ADD CONSTRAINT [FK_Rateplan_ProductGuidType] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

