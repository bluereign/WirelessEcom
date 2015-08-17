CREATE TABLE [ATT].[Load_Rateplan]
(
[RateplanGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractTerm] [int] NULL,
[IncludedLines] [int] NULL,
[MaxLines] [int] NULL,
[MonthlyFee] [money] NULL,
[AdditionalLineBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalLineFee] [money] NULL,
[PrimaryActivationFee] [money] NULL,
[SecondaryActivationFee] [money] NULL,
[IsShared] [bit] NOT NULL CONSTRAINT [DF__Load_Rate__IsSha__7C81192A] DEFAULT ((0))
) ON [PRIMARY]
GO
