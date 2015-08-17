ALTER TABLE [dbo].[UserCoupon]
    ADD CONSTRAINT [FK_UserCoupon_Coupon] FOREIGN KEY ([CouponId]) REFERENCES [dbo].[Coupon] ([CouponId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

