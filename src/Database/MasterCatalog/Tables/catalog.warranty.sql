CREATE TABLE [catalog].[warranty]
(
[WarrantyGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF__warranty__Warran__7AF7F814] DEFAULT (newid()),
[CarrierId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__warranty__Carrie__7BEC1C4D] DEFAULT ('0,42,109,128,299'),
[UPC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractTerm] [int] NULL,
[Price] [money] NULL,
[Deductible] [money] NULL,
[MonthlyFee] [money] NULL,
[AdditionalDevicePrice] [money] NULL,
[AdditionalDeviceDeductible] [money] NULL,
[AdditionalDeviceMonthlyFee] [money] NULL,
[CompanyGuid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[warranty] ADD CONSTRAINT [PK__warranty__09A3BEC3790FAFA2] PRIMARY KEY CLUSTERED  ([WarrantyGuid]) ON [PRIMARY]
GO
