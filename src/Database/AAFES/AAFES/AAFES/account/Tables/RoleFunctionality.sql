CREATE TABLE [account].[RoleFunctionality] (
    [RoleGuid]          UNIQUEIDENTIFIER NOT NULL,
    [FunctionalityGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RoleFunctionality] PRIMARY KEY CLUSTERED ([RoleGuid] ASC, [FunctionalityGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleFunctionality', @level2type = N'COLUMN', @level2name = N'FunctionalityGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleFunctionality', @level2type = N'COLUMN', @level2name = N'FunctionalityGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleFunctionality', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleFunctionality', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [Account].[Role] + [Account].[Functionality]', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleFunctionality';

