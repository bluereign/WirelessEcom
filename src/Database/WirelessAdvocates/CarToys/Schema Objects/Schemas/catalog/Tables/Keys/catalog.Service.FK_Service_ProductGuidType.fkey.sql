ALTER TABLE [catalog].[Service]
    ADD CONSTRAINT [FK_Service_ProductGuidType] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

