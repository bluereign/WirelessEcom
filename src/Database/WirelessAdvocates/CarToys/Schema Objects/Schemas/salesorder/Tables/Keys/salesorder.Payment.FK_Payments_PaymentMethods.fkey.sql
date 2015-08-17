ALTER TABLE [salesorder].[Payment]
    ADD CONSTRAINT [FK_Payments_PaymentMethods] FOREIGN KEY ([PaymentMethodId]) REFERENCES [salesorder].[PaymentMethod] ([PaymentMethodId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

