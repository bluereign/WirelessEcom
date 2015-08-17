ALTER TABLE [catalog].[ServiceMaster]
    ADD CONSTRAINT [DF_ServiceMaster_ServiceMasterId] DEFAULT (newid()) FOR [ServiceMasterGuid];

