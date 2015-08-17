CREATE TABLE [account].[RoleMenu] (
    [RoleGuid] UNIQUEIDENTIFIER NOT NULL,
    [MenuGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RoleMenu] PRIMARY KEY CLUSTERED ([RoleGuid] ASC, [MenuGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key. Links to [dbo].[AdminMenu].[AdminMenuId]', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleMenu', @level2type = N'COLUMN', @level2name = N'MenuGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleMenu', @level2type = N'COLUMN', @level2name = N'MenuGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleMenu', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleMenu', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [Account].[Role] + [dbo].[AdminMenu]', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'RoleMenu';

