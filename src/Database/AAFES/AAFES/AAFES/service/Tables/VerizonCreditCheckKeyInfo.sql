CREATE TABLE [service].[VerizonCreditCheckKeyInfo] (
    [VerizonCreditCheckKeyInfoId] INT           IDENTITY (1, 1) NOT NULL,
    [CreditApplicationNum]        NVARCHAR (20) NULL,
    [BillingSystem]               NVARCHAR (5)  NULL,
    [ClusterInfo]                 NVARCHAR (20) NULL,
    [Location]                    NVARCHAR (20) NULL,
    [OrderNum]                    NVARCHAR (20) NULL,
    [OutletId]                    NVARCHAR (20) NULL,
    [SalesForceId]                NVARCHAR (20) NULL,
    CONSTRAINT [PK_VerizonCreditCheck] PRIMARY KEY CLUSTERED ([VerizonCreditCheckKeyInfoId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'VerizonCreditCheckKeyInfo', @level2type = N'COLUMN', @level2name = N'VerizonCreditCheckKeyInfoId';

