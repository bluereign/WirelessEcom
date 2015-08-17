CREATE TABLE [catalog].[RateplanMarket] (
    [RateplanGuid]         UNIQUEIDENTIFIER NOT NULL,
    [MarketGuid]           UNIQUEIDENTIFIER NOT NULL,
    [CarrierPlanReference] NVARCHAR (15)    NULL
);

