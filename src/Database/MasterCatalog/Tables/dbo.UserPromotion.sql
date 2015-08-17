CREATE TABLE [dbo].[UserPromotion]
(
[UserId] [int] NOT NULL,
[PromotionId] [int] NOT NULL,
[IsRedeemed] [bit] NOT NULL CONSTRAINT [DF_UserPromotion_IsRedeemed] DEFAULT ((0))
) ON [PRIMARY]
GO
