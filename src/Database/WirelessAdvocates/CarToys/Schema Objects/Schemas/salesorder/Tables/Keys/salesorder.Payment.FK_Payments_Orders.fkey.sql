ALTER TABLE [salesorder].[Payment]
    ADD CONSTRAINT [FK_Payments_Orders] FOREIGN KEY ([OrderId]) REFERENCES [salesorder].[Order] ([OrderId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

