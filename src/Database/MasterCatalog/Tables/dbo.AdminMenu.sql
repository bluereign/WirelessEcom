CREATE TABLE [dbo].[AdminMenu]
(
[AdminMenuId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_AdminMenu_AdminMenuId] DEFAULT (newid()),
[Label] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayFile] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentId] [uniqueidentifier] NULL,
[IsActive] [bit] NULL,
[Ordinal] [int] NULL,
[ChannelID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminMenu] ADD CONSTRAINT [PK_AdminMenu] PRIMARY KEY CLUSTERED  ([AdminMenuId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'dbo', 'TABLE', N'AdminMenu', 'COLUMN', N'AdminMenuId'
GO
