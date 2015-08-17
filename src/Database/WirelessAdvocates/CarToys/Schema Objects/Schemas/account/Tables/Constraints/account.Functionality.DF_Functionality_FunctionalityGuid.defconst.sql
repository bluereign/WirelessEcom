ALTER TABLE [account].[Functionality]
    ADD CONSTRAINT [DF_Functionality_FunctionalityGuid] DEFAULT (newid()) FOR [FunctionalityGuid];

