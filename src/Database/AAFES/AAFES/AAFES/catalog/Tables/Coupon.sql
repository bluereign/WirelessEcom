CREATE TABLE [catalog].[Coupon] (
    [CouponId]       INT          IDENTITY (1, 1) NOT NULL,
    [CouponCode]     VARCHAR (50) NOT NULL,
    [ValidStartDate] DATETIME     NOT NULL,
    [ValidEndDate]   DATETIME     NOT NULL,
    [DateCreated]    DATETIME     CONSTRAINT [DF_Coupon_DateCreated] DEFAULT (getdate()) NOT NULL,
    [DiscountValue]  MONEY        NOT NULL,
    [CreatedBy]      INT          NULL,
    [LastUpdated]    DATETIME     NULL,
    [UpdatedBy]      INT          NULL,
    [MinPurchase]    MONEY        NULL,
    CONSTRAINT [PK_Coupon] PRIMARY KEY CLUSTERED ([CouponId] ASC),
    CONSTRAINT [FK__Coupon__CreatedB__1D57FD10] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([User_ID])
);

