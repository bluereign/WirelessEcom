ALTER TABLE [catalog].[DeviceService]
    ADD CONSTRAINT [FK_DeviceService_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

