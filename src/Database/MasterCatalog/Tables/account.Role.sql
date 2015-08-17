CREATE TABLE [account].[Role]
(
[RoleGuid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Role_RoleGuid] DEFAULT (newid()),
[Role] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [account].[Role] ADD CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED  ([RoleGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of all role types on the site.', 'SCHEMA', N'account', 'TABLE', N'Role', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'Role', 'COLUMN', N'Role'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of role on site, like Admin versus ContentEditor, etc.', 'SCHEMA', N'account', 'TABLE', N'Role', 'COLUMN', N'Role'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'Role', 'COLUMN', N'RoleGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'Role', 'COLUMN', N'RoleGuid'
GO
