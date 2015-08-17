ALTER TABLE [catalog].[DeviceFreeAccessory]
    ADD CONSTRAINT [DF_DeviceFreeAccessory_DeviceFreeAccessoryGuid] DEFAULT (newid()) FOR [DeviceFreeAccessoryGuid];

