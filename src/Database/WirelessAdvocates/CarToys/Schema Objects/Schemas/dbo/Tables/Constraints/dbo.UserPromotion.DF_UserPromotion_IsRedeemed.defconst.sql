ALTER TABLE [dbo].[UserPromotion]
    ADD CONSTRAINT [DF_UserPromotion_IsRedeemed] DEFAULT ((0)) FOR [IsRedeemed];

