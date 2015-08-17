ALTER TABLE [dbo].[UserPromotion]
    ADD CONSTRAINT [FK_UserPromotion_PromotionCodes] FOREIGN KEY ([PromotionId]) REFERENCES [dbo].[PromotionCodes] ([PromotionId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

