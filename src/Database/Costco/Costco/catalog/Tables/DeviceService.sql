CREATE TABLE [catalog].[DeviceService] (
    [DeviceGuid]  UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid] UNIQUEIDENTIFIER NOT NULL,
    [IsDefault]   BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DeviceService] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC, [ServiceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_DeviceService_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]),
    CONSTRAINT [FK_DeviceService_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
);


GO
ALTER TABLE [catalog].[DeviceService] NOCHECK CONSTRAINT [FK_DeviceService_Device];


GO
CREATE NONCLUSTERED INDEX [IX_ServiceGuid_DeviceGuid]
    ON [catalog].[DeviceService]([ServiceGuid] ASC, [DeviceGuid] ASC) WITH (FILLFACTOR = 80);

