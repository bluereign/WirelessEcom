ALTER TABLE [account].[Role]
    ADD CONSTRAINT [DF_Role_RoleGuid] DEFAULT (newid()) FOR [RoleGuid];

