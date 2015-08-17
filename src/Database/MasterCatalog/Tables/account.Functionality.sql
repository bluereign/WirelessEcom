CREATE TABLE [account].[Functionality]
(
[FunctionalityGuid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Functionality_FunctionalityGuid] DEFAULT (newid()),
[Functionality] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [account].[Functionality] ADD CONSTRAINT [PK_Functionality] PRIMARY KEY CLUSTERED  ([FunctionalityGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determines what a user account on the site is able to access.', 'SCHEMA', N'account', 'TABLE', N'Functionality', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of access level rights', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'Functionality'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Access level rights', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'Functionality'
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'FunctionalityGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'account', 'TABLE', N'Functionality', 'COLUMN', N'FunctionalityGuid'
GO
