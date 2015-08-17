ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_costatus] DEFAULT (0) FOR [costatus];

