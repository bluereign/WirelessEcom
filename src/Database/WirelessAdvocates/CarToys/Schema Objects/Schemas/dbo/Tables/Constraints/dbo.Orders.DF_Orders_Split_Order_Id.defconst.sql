ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_Split_Order_Id] DEFAULT (0) FOR [Split_Order_Id];

