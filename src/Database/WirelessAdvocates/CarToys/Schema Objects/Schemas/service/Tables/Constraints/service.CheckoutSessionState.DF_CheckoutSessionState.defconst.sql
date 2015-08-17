ALTER TABLE [service].[CheckoutSessionState]
    ADD CONSTRAINT [DF_CheckoutSessionState] DEFAULT (newid()) FOR [CheckoutSessionStateGUID];

