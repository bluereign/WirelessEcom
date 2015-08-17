CREATE TABLE [account].[UserRole] (
    [UserId]   INT              NOT NULL,
    [RoleGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'RoleGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'UserRole', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [Account].[Role] + [dbo].[Users]', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'UserRole';

