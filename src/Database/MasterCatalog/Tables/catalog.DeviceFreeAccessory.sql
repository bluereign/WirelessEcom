CREATE TABLE [catalog].[DeviceFreeAccessory]
(
[DeviceFreeAccessoryGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_DeviceFreeAccessory_DeviceFreeAccessoryGuid] DEFAULT (newid()),
[DeviceGuid] [uniqueidentifier] NOT NULL,
[ProductGuid] [uniqueidentifier] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
