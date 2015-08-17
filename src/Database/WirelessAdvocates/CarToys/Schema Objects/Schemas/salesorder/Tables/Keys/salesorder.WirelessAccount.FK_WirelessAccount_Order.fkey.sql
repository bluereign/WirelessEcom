ALTER TABLE [salesorder].[WirelessAccount]
    ADD CONSTRAINT [FK_WirelessAccount_Order] FOREIGN KEY ([OrderId]) REFERENCES [salesorder].[Order] ([OrderId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

