ALTER TABLE [salesorder].[Activity]
    ADD CONSTRAINT [DF_Activity_Timestamp] DEFAULT (getdate()) FOR [Timestamp];

