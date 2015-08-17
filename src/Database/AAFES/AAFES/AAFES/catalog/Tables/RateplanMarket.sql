CREATE TABLE [catalog].[RateplanMarket] (
    [RateplanGuid]         UNIQUEIDENTIFIER NOT NULL,
    [MarketGuid]           UNIQUEIDENTIFIER NOT NULL,
    [CarrierPlanReference] NVARCHAR (15)    NULL,
    CONSTRAINT [PK_RateplanMarket] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC, [MarketGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_RateplanMarket_Market] FOREIGN KEY ([MarketGuid]) REFERENCES [catalog].[Market] ([MarketGuid]),
    CONSTRAINT [FK_RateplanMarket_Rateplan] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[Rateplan] ([RateplanGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Market table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanMarket', @level2type = N'COLUMN', @level2name = N'MarketGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Rateplan table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'RateplanMarket', @level2type = N'COLUMN', @level2name = N'RateplanGuid';

