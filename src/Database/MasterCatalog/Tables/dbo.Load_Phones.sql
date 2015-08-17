CREATE TABLE [dbo].[Load_Phones]
(
[PHONES_Id] [numeric] (20, 0) NULL,
[phone_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_network] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_vendor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fulfilled_yn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_color] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[battery_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[frequency_mhz] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lines_of_text] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_upc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_dimensions] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_effective_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_expiration_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_store_front_yn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standby_hrs] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[talk_time_minutes] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weight_ounces] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_Id2] [numeric] (20, 0) NULL
) ON [PRIMARY]
GO
