CREATE TABLE [catalog].[Service] (
    [ServiceGuid]      UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [CarrierServiceId] NVARCHAR (12)    NULL,
    [CarrierBillCode]  NVARCHAR (12)    NULL,
    [Title]            NVARCHAR (100)   NULL,
    [MonthlyFee]       MONEY            NULL,
    [CartTypeId]       NVARCHAR (50)    NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Used by the catalog loader to match services in the incoming catalog to existing services', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Service', @level2type = N'COLUMN', @level2name = N'CarrierServiceId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The code to be sent to the carrier when activating the service. This can be null for included services.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Service', @level2type = N'COLUMN', @level2name = N'CarrierBillCode';

