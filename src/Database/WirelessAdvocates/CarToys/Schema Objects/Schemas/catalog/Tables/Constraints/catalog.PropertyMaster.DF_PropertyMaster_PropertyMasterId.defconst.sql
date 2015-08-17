ALTER TABLE [catalog].[PropertyMaster]
    ADD CONSTRAINT [DF_PropertyMaster_PropertyMasterId] DEFAULT (newid()) FOR [PropertyMasterGuid];

