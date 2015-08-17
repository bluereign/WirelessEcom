CREATE TABLE [account].[RoleMenu]
(
[RoleGuid] [uniqueidentifier] NOT NULL,
[MenuGuid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [account].[RoleMenu] ADD CONSTRAINT [PK_RoleMenu] PRIMARY KEY CLUSTERED  ([RoleGuid], [MenuGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [Account].[Role] + [dbo].[AdminMenu]', 'SCHEMA', N'account', 'TABLE', N'RoleMenu', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'RoleMenu', 'COLUMN', N'MenuGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Links to [dbo].[AdminMenu].[AdminMenuId]', 'SCHEMA', N'account', 'TABLE', N'RoleMenu', 'COLUMN', N'MenuGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'RoleMenu', 'COLUMN', N'RoleGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'RoleMenu', 'COLUMN', N'RoleGuid'
GO
