ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF__Orders__SameAsUs__4CC05EF3] DEFAULT (0) FOR [SameAsUserInfo];

