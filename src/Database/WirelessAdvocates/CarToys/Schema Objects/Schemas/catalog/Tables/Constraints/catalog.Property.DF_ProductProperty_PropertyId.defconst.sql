ALTER TABLE [catalog].[Property]
    ADD CONSTRAINT [DF_ProductProperty_PropertyId] DEFAULT (newid()) FOR [PropertyGuid];

