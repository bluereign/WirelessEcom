ALTER TABLE [salesorder].[LineService]
    ADD CONSTRAINT [FK_LineService_OrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId]) ON DELETE NO ACTION ON UPDATE NO ACTION;

