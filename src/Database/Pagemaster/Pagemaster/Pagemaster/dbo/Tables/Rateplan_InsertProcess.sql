CREATE TABLE [dbo].[Rateplan_InsertProcess] (
    [RatePlanGuid]           UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]            UNIQUEIDENTIFIER NOT NULL,
    [CarrierBillCode]        VARCHAR (12)     NULL,
    [Title]                  VARCHAR (255)    NULL,
    [Description]            VARCHAR (255)    NULL,
    [Type]                   VARCHAR (3)      NULL,
    [ContractTerm]           INT              NULL,
    [IncludedLines]          INT              NULL,
    [MaxLines]               INT              NULL,
    [MonthlyFee]             DECIMAL (15, 10) NULL,
    [AdditionalLineBillCode] VARCHAR (12)     NULL,
    [AdditionalLineFee]      DECIMAL (15, 10) NULL,
    [PrimaryActivationFee]   DECIMAL (15, 10) NULL,
    [SecondaryActivationFee] DECIMAL (15, 10) NULL,
    [IsShared]               BIT              NULL
);

