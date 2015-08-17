CREATE TABLE [catalog].[DeviceService] (
    [DeviceGuid]  UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid] UNIQUEIDENTIFIER NOT NULL,
    [IsDefault]   BIT              DEFAULT ((0)) NOT NULL
);

