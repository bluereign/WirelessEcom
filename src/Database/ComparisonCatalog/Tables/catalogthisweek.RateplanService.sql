CREATE TABLE [catalogthisweek].[RateplanService]
(
[RateplanCarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ServiceCarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsIncluded] [bit] NOT NULL CONSTRAINT [DF_RateplanService_IsIncluded] DEFAULT ((0)),
[IsRequired] [bit] NOT NULL CONSTRAINT [DF_RateplanService_IsRequired] DEFAULT ((0)),
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_RateplanService_IsDefault] DEFAULT ((0))
) ON [PRIMARY]
GO
