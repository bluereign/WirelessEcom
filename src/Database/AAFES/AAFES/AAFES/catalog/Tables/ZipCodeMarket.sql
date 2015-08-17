CREATE TABLE [catalog].[ZipCodeMarket] (
    [ZipCode]    NVARCHAR (5)     NOT NULL,
    [MarketGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ZipCodeMarket] PRIMARY KEY CLUSTERED ([ZipCode] ASC, [MarketGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ZipCodeMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Market table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ZipCodeMarket', @level2type = N'COLUMN', @level2name = N'MarketGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ZipCodeMarket', @level2type = N'COLUMN', @level2name = N'ZipCode';

