CREATE TABLE [account].[UserRole]
(
[UserId] [int] NOT NULL,
[RoleGuid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [account].[UserRole] ADD CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED  ([UserId], [RoleGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [Account].[Role] + [dbo].[Users]', 'SCHEMA', N'account', 'TABLE', N'UserRole', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'UserRole', 'COLUMN', N'RoleGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'UserRole', 'COLUMN', N'RoleGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'UserRole', 'COLUMN', N'UserId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'UserRole', 'COLUMN', N'UserId'
GO
