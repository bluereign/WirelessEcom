CREATE TABLE [catalogthisweek].[ZipCodeMarket]
(
[ZipCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierMarketCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[ZipCodeMarket] ADD CONSTRAINT [PK_ZipCodeMarket_1] PRIMARY KEY CLUSTERED  ([ZipCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalogthisweek', 'TABLE', N'ZipCodeMarket', 'COLUMN', N'ZipCode'
GO
