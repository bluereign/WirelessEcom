ALTER TABLE [catalog].[Company]
    ADD CONSTRAINT [DF_Company_CompanyGuid] DEFAULT (newid()) FOR [CompanyGuid];

