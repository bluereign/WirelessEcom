CREATE TABLE [catalog].[warranty] (
    [WarrantyGuid]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [CarrierId]                  NVARCHAR (50)    DEFAULT ('0,42,109,128,299') NOT NULL,
    [UPC]                        NVARCHAR (20)    NULL,
    [Title]                      NVARCHAR (100)   NULL,
    [Description]                NVARCHAR (255)   NULL,
    [ContractTerm]               INT              NULL,
    [Price]                      MONEY            NULL,
    [Deductible]                 MONEY            NULL,
    [MonthlyFee]                 MONEY            NULL,
    [AdditionalDevicePrice]      MONEY            NULL,
    [AdditionalDeviceDeductible] MONEY            NULL,
    [AdditionalDeviceMonthlyFee] MONEY            NULL,
    [CompanyGuid]                UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([WarrantyGuid] ASC)
);

