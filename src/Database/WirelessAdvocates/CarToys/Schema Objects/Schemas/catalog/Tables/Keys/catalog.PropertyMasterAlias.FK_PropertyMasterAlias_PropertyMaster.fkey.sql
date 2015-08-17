ALTER TABLE [catalog].[PropertyMasterAlias]
    ADD CONSTRAINT [FK_PropertyMasterAlias_PropertyMaster] FOREIGN KEY ([PropertyMasterGuid]) REFERENCES [catalog].[PropertyMaster] ([PropertyMasterGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

