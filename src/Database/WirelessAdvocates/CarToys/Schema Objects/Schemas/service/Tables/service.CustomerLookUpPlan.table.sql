CREATE TABLE [service].[CustomerLookUpPlan] (
    [CustomerLookUpPlanId] INT           IDENTITY (1, 1) NOT NULL,
    [ReferenceNumber]      VARCHAR (50)  NULL,
    [CarrierId]            INT           NULL,
    [MDN]                  VARCHAR (10)  NULL,
    [IsPrimary]            BIT           NULL,
    [CarrierBillCode]      VARCHAR (15)  NULL,
    [Title]                VARCHAR (255) NULL
);

