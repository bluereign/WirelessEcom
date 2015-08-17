ALTER TABLE [salesorder].[WirelessLine]
    ADD CONSTRAINT [FK_WirelessLine_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

