CREATE TABLE [service].[CustomerLookUpService] (
    [CustomerLookUpServiceId] INT            IDENTITY (1, 1) NOT NULL,
    [CustomerLookUpPlanId]    INT            NULL,
    [ReferenceNumber]         VARCHAR (50)   NULL,
    [CarrierId]               INT            NULL,
    [CarrierBillCode]         NVARCHAR (12)  NULL,
    [Title]                   NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([CustomerLookUpServiceId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

