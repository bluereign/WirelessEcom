ALTER TABLE [catalog].[Market]
    ADD CONSTRAINT [FK_Market_Company] FOREIGN KEY ([CarrierGuid]) REFERENCES [catalog].[Company] ([CompanyGuid]) ON DELETE NO ACTION ON UPDATE NO ACTION;

