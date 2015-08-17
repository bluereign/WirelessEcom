ALTER TABLE [catalog].[ServiceExclusion]
    ADD CONSTRAINT [FK_ServiceExclusion_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

