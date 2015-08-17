CREATE TABLE [dbo].[Rateplan_InsertProcess]
(
[RatePlanGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[CarrierBillCode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractTerm] [int] NULL,
[IncludedLines] [int] NULL,
[MaxLines] [int] NULL,
[MonthlyFee] [decimal] (15, 10) NULL,
[AdditionalLineBillCode] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalLineFee] [decimal] (15, 10) NULL,
[PrimaryActivationFee] [decimal] (15, 10) NULL,
[SecondaryActivationFee] [decimal] (15, 10) NULL,
[IsShared] [bit] NULL
) ON [PRIMARY]
GO
