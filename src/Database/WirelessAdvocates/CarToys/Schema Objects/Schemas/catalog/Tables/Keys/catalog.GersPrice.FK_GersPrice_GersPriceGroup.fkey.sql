ALTER TABLE [catalog].[GersPrice]
    ADD CONSTRAINT [FK_GersPrice_GersPriceGroup] FOREIGN KEY ([PriceGroupCode]) REFERENCES [catalog].[GersPriceGroup] ([PriceGroupCode]) ON DELETE NO ACTION ON UPDATE NO ACTION;

