CREATE TABLE [ATT].[Load_Service]
(
[ServiceGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[CarrierServiceId] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthlyFee] [money] NULL,
[CartTypeId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [ATT].[Load_Service] ADD CONSTRAINT [PK_Service] PRIMARY KEY CLUSTERED  ([ServiceGuid]) ON [PRIMARY]
GO
