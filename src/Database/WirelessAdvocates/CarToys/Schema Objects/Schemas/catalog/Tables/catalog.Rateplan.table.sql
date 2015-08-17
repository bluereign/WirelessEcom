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
    [SecondaryActivationFee] MONEY            NULL
);

