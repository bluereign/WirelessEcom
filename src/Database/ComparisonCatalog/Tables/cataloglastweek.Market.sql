CREATE TABLE [cataloglastweek].[Market]
(
[CarrierName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierMarketCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierMarketName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierMarketId] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determines which markets carriers supply services for.', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Market', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Market', 'COLUMN', N'CarrierName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to Company table', 'SCHEMA', N'cataloglastweek', 'TABLE', N'Market', 'COLUMN', N'CarrierName'
GO
