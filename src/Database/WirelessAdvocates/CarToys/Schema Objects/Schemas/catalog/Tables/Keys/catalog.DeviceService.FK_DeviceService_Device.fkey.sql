ALTER TABLE [catalog].[DeviceService]
    ADD CONSTRAINT [FK_DeviceService_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
ALTER TABLE [catalog].[DeviceService] NOCHECK CONSTRAINT [FK_DeviceService_Device];

