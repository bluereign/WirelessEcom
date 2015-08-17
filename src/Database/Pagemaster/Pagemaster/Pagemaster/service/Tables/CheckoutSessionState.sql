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
CREATE NONCLUSTERED INDEX [IX_RefSubServ_index]
    ON [service].[CheckoutSessionState]([ReferenceNumber] ASC, [SubReferenceNumber] ASC, [ServiceCall] ASC);

