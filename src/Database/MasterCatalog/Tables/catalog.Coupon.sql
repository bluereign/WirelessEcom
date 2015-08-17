CREATE TABLE [catalog].[Coupon]
(
[CouponId] [int] NOT NULL,
[CouponCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ValidStartDate] [datetime] NOT NULL,
[ValidEndDate] [datetime] NOT NULL,
[DateCreated] [datetime] NOT NULL,
[DiscountValue] [money] NOT NULL,
[CreatedBy] [int] NULL,
[LastUpdated] [datetime] NULL,
[UpdatedBy] [int] NULL,
[MinPurchase] [money] NULL,
[ChannelId] [int] NULL
) ON [PRIMARY]
GO
