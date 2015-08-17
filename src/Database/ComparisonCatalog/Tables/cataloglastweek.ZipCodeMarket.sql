CREATE TABLE [cataloglastweek].[ZipCodeMarket]
(
[ZipCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CarrierMarketCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [cataloglastweek].[ZipCodeMarket] ADD CONSTRAINT [PK_ZipCodeMarket] PRIMARY KEY CLUSTERED  ([ZipCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'cataloglastweek', 'TABLE', N'ZipCodeMarket', 'COLUMN', N'ZipCode'
GO
