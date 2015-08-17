CREATE TABLE [catalog].[DeviceFreeAccessory] (
    [DeviceFreeAccessoryGuid] UNIQUEIDENTIFIER NOT NULL,
    [DeviceGuid]              UNIQUEIDENTIFIER NOT NULL,
    [ProductGuid]             UNIQUEIDENTIFIER NOT NULL,
    [StartDate]               DATETIME         NOT NULL,
    [EndDate]                 DATETIME         NOT NULL
);

