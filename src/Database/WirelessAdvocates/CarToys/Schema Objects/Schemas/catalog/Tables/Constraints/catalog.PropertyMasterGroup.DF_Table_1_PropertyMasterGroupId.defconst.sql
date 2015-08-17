ALTER TABLE [catalog].[PropertyMasterGroup]
    ADD CONSTRAINT [DF_Table_1_PropertyMasterGroupId] DEFAULT (newid()) FOR [PropertyMasterGroupGuid];

