ALTER TABLE [catalog].[RateplanDevice]
    ADD CONSTRAINT [FK_RateplanDevice_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
ALTER TABLE [catalog].[RateplanDevice] NOCHECK CONSTRAINT [FK_RateplanDevice_Device];

