CREATE TABLE [catalog].[ZipCodeMarket] (
    [ZipCode]    NVARCHAR (5)     NOT NULL,
    [MarketGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ZipCodeMarket] PRIMARY KEY CLUSTERED ([ZipCode] ASC, [MarketGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ZipCodeMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid])
);

