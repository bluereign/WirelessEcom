CREATE TABLE [account].[Role] (
    [RoleGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Role_RoleGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Role]     VARCHAR (50)     NOT NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([RoleGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Type of role on site, like Admin versus ContentEditor, etc.', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'Role';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'Role';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Role', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of all role types on the site.', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Role';

