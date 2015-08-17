ALTER TABLE [catalog].[Company]
    ADD CONSTRAINT [DF_Company_IsCarrier] DEFAULT ((0)) FOR [IsCarrier];

