CREATE TABLE [service].[CheckoutSessionState] (
    [CheckoutSessionStateGUID] UNIQUEIDENTIFIER CONSTRAINT [DF_CheckoutSessionState] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ReferenceNumber]          VARCHAR (50)     NULL,
    [SubReferenceNumber]       VARCHAR (50)     NULL,
    [ServiceCall]              VARCHAR (50)     NULL,
    [Value]                    TEXT             NULL,
    [CreatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_CheckoutSessionState] PRIMARY KEY CLUSTERED ([CheckoutSessionStateGUID] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'service', @level1type = N'TABLE', @level1name = N'CheckoutSessionState', @level2type = N'COLUMN', @level2name = N'CheckoutSessionStateGUID';

