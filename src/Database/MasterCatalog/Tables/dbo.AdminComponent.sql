CREATE TABLE [dbo].[AdminComponent]
(
[AdminComponentId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_AdminComponent_AdminComponentId] DEFAULT (newid()),
[AdminMenuId] [uniqueidentifier] NULL,
[Component] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ordinal] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AdminComponent] ADD CONSTRAINT [PK_AdminComponent] PRIMARY KEY CLUSTERED  ([AdminComponentId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'dbo', 'TABLE', N'AdminComponent', 'COLUMN', N'AdminComponentId'
GO
