ALTER TABLE [dbo].[UserCoupon]
    ADD CONSTRAINT [DF_UserCoupon_IsRedeemed] DEFAULT ((0)) FOR [IsRedeemed];

