CREATE TABLE [catalog].[Market] (
    [MarketGuid]        UNIQUEIDENTIFIER CONSTRAINT [DF_CarrierMarket_MarketGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [CarrierGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierMarketCode] NVARCHAR (30)    NOT NULL,
    [CarrierMarketName] NVARCHAR (30)    NOT NULL,
    CONSTRAINT [FK_Market_Company] FOREIGN KEY ([CarrierGuid]) REFERENCES [catalog].[Company] ([CompanyGuid])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Market]
    ON [catalog].[Market]([MarketGuid] ASC);

