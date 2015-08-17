CREATE TABLE [catalog].[DeviceFreeAccessory] (
    [DeviceFreeAccessoryGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_DeviceFreeAccessory_DeviceFreeAccessoryGuid] DEFAULT (newid()) NOT NULL,
    [DeviceGuid]              UNIQUEIDENTIFIER NOT NULL,
    [ProductGuid]             UNIQUEIDENTIFIER NOT NULL,
    [StartDate]               DATETIME         NOT NULL,
    [EndDate]                 DATETIME         NOT NULL
);


GO
CREATE STATISTICS [_dta_stat_1585492777_2_3]
    ON [catalog].[DeviceFreeAccessory]([DeviceGuid], [ProductGuid]);


GO
CREATE STATISTICS [_dta_stat_1585492777_3]
    ON [catalog].[DeviceFreeAccessory]([ProductGuid]);

