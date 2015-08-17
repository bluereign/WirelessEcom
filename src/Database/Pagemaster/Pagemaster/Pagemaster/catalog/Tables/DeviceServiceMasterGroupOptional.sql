CREATE TABLE [catalog].[DeviceServiceMasterGroupOptional] (
    [DeviceGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_DeviceServiceMasterGroupOptional] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC) WITH (FILLFACTOR = 80)
);

