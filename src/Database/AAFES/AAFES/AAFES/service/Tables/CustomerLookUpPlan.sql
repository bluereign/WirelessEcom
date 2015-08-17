CREATE TABLE [service].[CustomerLookUpPlan] (
    [CustomerLookUpPlanId] INT           IDENTITY (1, 1) NOT NULL,
    [ReferenceNumber]      VARCHAR (50)  NULL,
    [CarrierId]            INT           NULL,
    [MDN]                  VARCHAR (10)  NULL,
    [IsPrimary]            BIT           NULL,
    [CarrierBillCode]      VARCHAR (15)  NULL,
    [Title]                VARCHAR (255) NULL,
    CONSTRAINT [PK__Customer__8204AE0D04053AF3] PRIMARY KEY CLUSTERED ([CustomerLookUpPlanId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'CustomerLookUpPlan', @level2type = N'COLUMN', @level2name = N'CustomerLookUpPlanId';

