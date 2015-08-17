ALTER TABLE [catalog].[ServiceMaster]
    ADD CONSTRAINT [FK_ServiceMaster_ServiceMasterGroup] FOREIGN KEY ([ServiceMasterGroupGuid]) REFERENCES [catalog].[ServiceMasterGroup] ([ServiceMasterGroupGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

