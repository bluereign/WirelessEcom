CREATE TABLE [catalog].[RateplanMarket] (
    [RateplanGuid]         UNIQUEIDENTIFIER NOT NULL,
    [MarketGuid]           UNIQUEIDENTIFIER NOT NULL,
    [CarrierPlanReference] NVARCHAR (15)    NULL,
    CONSTRAINT [PK_RateplanMarket] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC, [MarketGuid] ASC),
    CONSTRAINT [FK_RateplanMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid]),
    CONSTRAINT [FK_RateplanMarket_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid])
);

