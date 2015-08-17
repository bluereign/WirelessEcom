ALTER TABLE [catalog].[RateplanService]
    ADD CONSTRAINT [DF_RateplanService_IsIncluded] DEFAULT ((0)) FOR [IsIncluded];

