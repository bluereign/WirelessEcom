CREATE TABLE [service].[CustomerLookUpService] (
    [CustomerLookUpServiceId] INT            IDENTITY (1, 1) NOT NULL,
    [CustomerLookUpPlanId]    INT            NULL,
    [ReferenceNumber]         VARCHAR (50)   NULL,
    [CarrierId]               INT            NULL,
    [CarrierBillCode]         NVARCHAR (12)  NULL,
    [Title]                   NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([CustomerLookUpServiceId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'CustomerLookUpService', @level2type = N'COLUMN', @level2name = N'CustomerLookUpServiceId';

