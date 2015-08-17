ALTER TABLE [dbo].[PromotionCodes]
    ADD CONSTRAINT [DF_PromotionCodes_DateCreated] DEFAULT (getdate()) FOR [DateCreated];

