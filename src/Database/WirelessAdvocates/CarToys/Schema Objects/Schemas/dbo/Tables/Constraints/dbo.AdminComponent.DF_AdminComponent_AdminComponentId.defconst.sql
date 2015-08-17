ALTER TABLE [dbo].[AdminComponent]
    ADD CONSTRAINT [DF_AdminComponent_AdminComponentId] DEFAULT (newid()) FOR [AdminComponentId];

