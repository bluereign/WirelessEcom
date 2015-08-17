ALTER TABLE [catalog].[RateplanService]
    ADD CONSTRAINT [FK_RateplanService_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

