ALTER TABLE [dbo].[AdminMenu]
    ADD CONSTRAINT [DF_AdminMenu_AdminMenuId] DEFAULT (newid()) FOR [AdminMenuId];

