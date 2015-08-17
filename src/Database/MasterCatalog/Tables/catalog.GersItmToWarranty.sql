CREATE TABLE [catalog].[GersItmToWarranty]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WarrantySku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WarrantyPrice] [smallmoney] NULL,
[ChannelId] [int] NULL
) ON [PRIMARY]
GO
