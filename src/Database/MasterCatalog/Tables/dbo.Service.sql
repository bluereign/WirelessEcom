CREATE TABLE [dbo].[Service]
(
[ServiceGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[CarrierServiceID] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthlyFee] [decimal] (15, 10) NULL,
[CartTypeId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
