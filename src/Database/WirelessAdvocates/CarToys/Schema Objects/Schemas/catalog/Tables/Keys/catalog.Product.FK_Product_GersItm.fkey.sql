ALTER TABLE [catalog].[Product]
    ADD CONSTRAINT [FK_Product_GersItm] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]) ON DELETE NO ACTION ON UPDATE NO ACTION;

