CREATE TABLE [catalog].[DeviceMarket]
(
[DeviceGuid] [uniqueidentifier] NOT NULL,
[MarketGuid] [uniqueidentifier] NOT NULL,
[CarrierPlanReference] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[DeviceMarket] ADD CONSTRAINT [PK_DeviceMarket] PRIMARY KEY CLUSTERED  ([DeviceGuid], [MarketGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [catalog].[DeviceMarket] WITH NOCHECK ADD CONSTRAINT [FK_DeviceMarket_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid])
GO
ALTER TABLE [catalog].[DeviceMarket] ADD CONSTRAINT [FK_DeviceMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid])
GO
