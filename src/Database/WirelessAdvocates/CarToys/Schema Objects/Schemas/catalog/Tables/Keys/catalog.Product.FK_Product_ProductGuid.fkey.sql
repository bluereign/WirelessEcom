ALTER TABLE [catalog].[Product]
    ADD CONSTRAINT [FK_Product_ProductGuid] FOREIGN KEY ([ProductGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

