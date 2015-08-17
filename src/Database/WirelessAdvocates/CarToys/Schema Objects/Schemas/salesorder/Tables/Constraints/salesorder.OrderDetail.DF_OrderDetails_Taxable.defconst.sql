ALTER TABLE [salesorder].[OrderDetail]
    ADD CONSTRAINT [DF_OrderDetails_Taxable] DEFAULT ((1)) FOR [Taxable];

