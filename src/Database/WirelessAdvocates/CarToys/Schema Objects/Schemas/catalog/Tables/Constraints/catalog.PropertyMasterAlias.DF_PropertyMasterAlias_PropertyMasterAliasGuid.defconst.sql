ALTER TABLE [catalog].[PropertyMasterAlias]
    ADD CONSTRAINT [DF_PropertyMasterAlias_PropertyMasterAliasGuid] DEFAULT (newid()) FOR [PropertyMasterAliasGuid];

