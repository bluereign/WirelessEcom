CREATE TABLE [service].[CheckoutSessionState] (
    [CheckoutSessionStateGUID] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ReferenceNumber]          VARCHAR (50)     NULL,
    [SubReferenceNumber]       VARCHAR (50)     NULL,
    [ServiceCall]              VARCHAR (50)     NULL,
    [Value]                    TEXT             NULL,
    [CreatedDate]              DATETIME         NULL
);

