CREATE TABLE [catalog].[Rateplan] (
    [RateplanGuid]           UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]            UNIQUEIDENTIFIER NOT NULL,
    [CarrierBillCode]        NVARCHAR (12)    NOT NULL,
    [Title]                  NVARCHAR (255)   NULL,
    [Description]            NVARCHAR (255)   NULL,
    [Type]                   NVARCHAR (3)     NULL,
    [ContractTerm]           INT              NULL,
    [IncludedLines]          INT              NULL,
    [MaxLines]               INT              NULL,
    [MonthlyFee]             MONEY            NULL,
    [AdditionalLineBillCode] NVARCHAR (12)    NULL,
    [AdditionalLineFee]      MONEY            NULL,
    [PrimaryActivationFee]   MONEY            NULL,
    [SecondaryActivationFee] MONEY            NULL,
    [IsShared]               BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Rateplan] PRIMARY KEY CLUSTERED ([RateplanGuid] ASC),
    CONSTRAINT [FK_Rateplan_ProductGuidType] FOREIGN KEY ([RateplanGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]),
    CONSTRAINT [IX_Rateplan_CarrierBillCode] UNIQUE NONCLUSTERED ([CarrierGuid] ASC, [CarrierBillCode] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Rateplan]
    ON [catalog].[Rateplan]([RateplanGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'Release', @value = N'3.4.0', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'IsShared';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'IsShared';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Implemented to originally handle Verizon Share plans', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'IsShared';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'27-JUN-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'IsShared';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'3654: http://tfserver:8080/tfs/web/wi.aspx?pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527&id=3654', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'IsShared';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to ProductGuid table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Rateplan', @level2type = N'COLUMN', @level2name = N'RateplanGuid';

