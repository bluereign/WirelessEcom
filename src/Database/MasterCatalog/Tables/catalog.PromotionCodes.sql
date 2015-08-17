CREATE TABLE [catalog].[PromotionCodes]
(
[PromotionId] [int] NOT NULL IDENTITY(1, 1),
[Code] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Discount] [decimal] (5, 2) NULL,
[MaxQuantity] [int] NULL,
[MaxQuantityPerUser] [int] NULL CONSTRAINT [df_MaxQuantityPerUser] DEFAULT ((1)),
[MaxQuantityPerOrder] [int] NULL CONSTRAINT [df_MaxQuantityPerOrder] DEFAULT ((1)),
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[PromotionTypeId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[PromotionCodes] ADD CONSTRAINT [PK__Promotio__52C42FCF0457451C] PRIMARY KEY CLUSTERED  ([PromotionId]) ON [PRIMARY]
GO
ALTER TABLE [catalog].[PromotionCodes] ADD CONSTRAINT [uc_Code] UNIQUE NONCLUSTERED  ([Code]) ON [PRIMARY]
GO
