CREATE TABLE [cataloglastweek].[Rateplan]
(
[CarrierName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AdditionalLineBillCode] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractTerm] [int] NULL,
[IncludedLines] [int] NULL,
[MaxLines] [int] NULL,
[MonthlyFee] [money] NULL,
[AdditionalLineFee] [money] NULL,
[PrimaryActivationFee] [money] NULL,
[SecondaryActivationFee] [money] NULL,
[CarrierRateplanId] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Rateplan__IsShar__44FF419A] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[Rateplan] ADD CONSTRAINT [PK_Rateplan_1] PRIMARY KEY CLUSTERED  ([CarrierBillCode]) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[Rateplan] ADD CONSTRAINT [IX_Rateplan_CarrierBillCode] UNIQUE NONCLUSTERED  ([CarrierName], [CarrierBillCode]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Bug', N'3654: http://tfserver:8080/tfs/web/wi.aspx?pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527&id=3654', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Rateplan', 'COLUMN', N'CarrierRateplanId'
GO
EXEC sp_addextendedproperty N'CreateDate', N'27-JUN-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Rateplan', 'COLUMN', N'CarrierRateplanId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Implemented to originally handle Verizon Share plans', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Rateplan', 'COLUMN', N'CarrierRateplanId'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Rateplan', 'COLUMN', N'CarrierRateplanId'
GO
EXEC sp_addextendedproperty N'Release', N'3.4.0', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Rateplan', 'COLUMN', N'CarrierRateplanId'
GO
