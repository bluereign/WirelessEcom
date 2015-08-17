ALTER TABLE [catalog].[PropertyMaster]
    ADD CONSTRAINT [FK_PropertyMaster_PropertyMasterGroup] FOREIGN KEY ([PropertyMasterGroupGuid]) REFERENCES [catalog].[PropertyMasterGroup] ([PropertyMasterGroupGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

