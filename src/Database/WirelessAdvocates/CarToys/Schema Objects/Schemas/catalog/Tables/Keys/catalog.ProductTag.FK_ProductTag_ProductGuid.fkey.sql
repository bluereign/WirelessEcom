ALTER TABLE [catalog].[ProductTag]
    ADD CONSTRAINT [FK_ProductTag_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

