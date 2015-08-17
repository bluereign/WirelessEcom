CREATE TABLE [account].[RoleFunctionality]
(
[RoleGuid] [uniqueidentifier] NOT NULL,
[FunctionalityGuid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [account].[RoleFunctionality] ADD CONSTRAINT [PK_RoleFunctionality] PRIMARY KEY CLUSTERED  ([RoleGuid], [FunctionalityGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ASSOCIATION. [Account].[Role] + [Account].[Functionality]', 'SCHEMA', N'account', 'TABLE', N'RoleFunctionality', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'RoleFunctionality', 'COLUMN', N'FunctionalityGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'RoleFunctionality', 'COLUMN', N'FunctionalityGuid'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'RoleFunctionality', 'COLUMN', N'RoleGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'RoleFunctionality', 'COLUMN', N'RoleGuid'
GO
