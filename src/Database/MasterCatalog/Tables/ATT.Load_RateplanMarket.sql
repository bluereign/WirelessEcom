CREATE TABLE [ATT].[Load_RateplanMarket]
(
[RateplanGuid] [uniqueidentifier] NOT NULL,
[MarketGuid] [uniqueidentifier] NOT NULL,
[CarrierPlanReference] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [ATT].[Load_RateplanMarket] ADD CONSTRAINT [PK_Load RateplanMarket] PRIMARY KEY CLUSTERED  ([RateplanGuid], [MarketGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
