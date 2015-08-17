ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_SentToGERS] DEFAULT (0) FOR [SentToGERS];

