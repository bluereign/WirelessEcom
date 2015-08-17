ALTER TABLE [catalog].[ServiceMasterGroup]
    ADD CONSTRAINT [DF_Table_1_ServiceMasterGroupId] DEFAULT (newid()) FOR [ServiceMasterGroupGuid];

