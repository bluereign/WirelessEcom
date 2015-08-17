ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_exported] DEFAULT (0) FOR [exported];

