CREATE TABLE [catalog].[Market] (
    [MarketGuid]        UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [CarrierGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierMarketCode] NVARCHAR (30)    NOT NULL,
    [CarrierMarketName] NVARCHAR (30)    NOT NULL
);

