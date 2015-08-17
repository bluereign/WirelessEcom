CREATE TABLE [catalog].[Market] (
    [MarketGuid]        UNIQUEIDENTIFIER CONSTRAINT [DF_CarrierMarket_MarketGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [CarrierGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierMarketCode] NVARCHAR (30)    NOT NULL,
    [CarrierMarketName] NVARCHAR (30)    NOT NULL,
    CONSTRAINT [PK_Market] PRIMARY KEY CLUSTERED ([MarketGuid] ASC),
    CONSTRAINT [FK_Market_Company] FOREIGN KEY ([CarrierGuid]) REFERENCES [catalog].[Company] ([CompanyGuid])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Market]
    ON [catalog].[Market]([MarketGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Company table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Market', @level2type = N'COLUMN', @level2name = N'CarrierGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Market', @level2type = N'COLUMN', @level2name = N'CarrierGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Market', @level2type = N'COLUMN', @level2name = N'MarketGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Market', @level2type = N'COLUMN', @level2name = N'MarketGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Determines which markets carriers supply services for.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Market';

