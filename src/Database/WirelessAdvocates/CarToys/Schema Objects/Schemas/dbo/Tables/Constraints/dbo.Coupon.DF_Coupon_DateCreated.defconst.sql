ALTER TABLE [dbo].[Coupon]
    ADD CONSTRAINT [DF_Coupon_DateCreated] DEFAULT (getdate()) FOR [DateCreated];

