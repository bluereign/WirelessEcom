CREATE TABLE [dbo].[Load_Attachables]
(
[attachable_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_network] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_price] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_effective_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_expiration_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attachable_desc] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mutually_exclusive_yn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deletion_soc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PLAN_Id] [numeric] (20, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
