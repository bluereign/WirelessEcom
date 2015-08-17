ALTER TABLE [catalog].[RateplanService]
    ADD CONSTRAINT [DF_RateplanService_IsRequired] DEFAULT ((0)) FOR [IsRequired];

