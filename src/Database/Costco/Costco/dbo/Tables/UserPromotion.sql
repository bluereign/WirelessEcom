CREATE TABLE [dbo].[UserPromotion] (
    [UserId]      INT NOT NULL,
    [PromotionId] INT NOT NULL,
    [IsRedeemed]  BIT CONSTRAINT [DF_UserPromotion_IsRedeemed] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [FK_UserPromotion_PromotionCodes] FOREIGN KEY ([PromotionId]) REFERENCES [dbo].[PromotionCodes] ([PromotionId])
);

