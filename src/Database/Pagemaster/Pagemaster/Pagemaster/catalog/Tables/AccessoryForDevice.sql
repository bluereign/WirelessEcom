CREATE TABLE [catalog].[AccessoryForDevice] (
    [DeviceGuid]    UNIQUEIDENTIFIER NOT NULL,
    [AccessoryGuid] UNIQUEIDENTIFIER NOT NULL,
    [Ordinal]       INT              CONSTRAINT [DF_OrderOne] DEFAULT ('1') NOT NULL,
    CONSTRAINT [uq_DeviceAccessoryCombo] UNIQUE NONCLUSTERED ([DeviceGuid] ASC, [AccessoryGuid] ASC)
);

