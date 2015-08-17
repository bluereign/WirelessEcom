ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_OrderType] DEFAULT (0) FOR [OrderType];

