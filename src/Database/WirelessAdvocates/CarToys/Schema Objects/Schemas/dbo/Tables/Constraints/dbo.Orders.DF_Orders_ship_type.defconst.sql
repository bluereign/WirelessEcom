ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_ship_type] DEFAULT (0) FOR [ship_type];

