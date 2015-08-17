ALTER TABLE [catalog].[RateplanService]
    ADD CONSTRAINT [DF_RateplanService_IsDefault] DEFAULT ((0)) FOR [IsDefault];

