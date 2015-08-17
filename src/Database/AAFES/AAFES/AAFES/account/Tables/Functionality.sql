CREATE TABLE [account].[Functionality] (
    [FunctionalityGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Functionality_FunctionalityGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Functionality]     VARCHAR (50)     NOT NULL,
    [Description]       VARCHAR (200)    NULL,
    CONSTRAINT [PK_Functionality] PRIMARY KEY CLUSTERED ([FunctionalityGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Description of access level rights', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Access level rights', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'Functionality';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'Functionality';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'FunctionalityGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality', @level2type = N'COLUMN', @level2name = N'FunctionalityGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Determines what a user account on the site is able to access.', @level0type = N'SCHEMA', @level0name = N'account', @level1type = N'TABLE', @level1name = N'Functionality';

