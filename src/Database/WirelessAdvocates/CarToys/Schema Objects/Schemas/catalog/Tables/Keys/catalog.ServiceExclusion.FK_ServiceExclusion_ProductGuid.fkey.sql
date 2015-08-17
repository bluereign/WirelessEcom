ALTER TABLE [catalog].[ServiceExclusion]
    ADD CONSTRAINT [FK_ServiceExclusion_ProductGuid] FOREIGN KEY ([ParentGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

