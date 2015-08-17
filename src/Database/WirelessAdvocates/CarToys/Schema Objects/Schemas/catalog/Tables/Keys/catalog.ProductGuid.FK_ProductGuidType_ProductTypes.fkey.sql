ALTER TABLE [catalog].[ProductGuid]
    ADD CONSTRAINT [FK_ProductGuidType_ProductTypes] FOREIGN KEY ([ProductTypeId]) REFERENCES [catalog].[ProductType] ([ProductTypeId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

