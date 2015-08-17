ALTER TABLE [catalog].[Service]
    ADD CONSTRAINT [FK_Service_Company] FOREIGN KEY ([CarrierGuid]) REFERENCES [catalog].[Company] ([CompanyGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

