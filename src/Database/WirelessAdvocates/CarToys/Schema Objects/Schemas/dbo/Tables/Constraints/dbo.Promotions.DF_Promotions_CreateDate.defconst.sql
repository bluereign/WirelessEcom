ALTER TABLE [dbo].[Promotions]
    ADD CONSTRAINT [DF_Promotions_CreateDate] DEFAULT (getdate()) FOR [CreateDate];

