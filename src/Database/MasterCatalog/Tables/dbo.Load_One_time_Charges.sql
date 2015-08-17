CREATE TABLE [dbo].[Load_One_time_Charges]
(
[otc_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otc_price] [decimal] (28, 10) NULL,
[otc_effective_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otc_expiration_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAN_Id] [numeric] (20, 0) NULL
) ON [PRIMARY]
GO
