CREATE TABLE [catalog].[Bundle]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bundle] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedOn] [datetime] NULL,
[Active] [bit] NULL,
[BundleXml] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [catalog].[Bundle] ADD CONSTRAINT [PK_Bundle] PRIMARY KEY CLUSTERED  ([Id]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'DELETION IN PROGRESS??? Currently not in use.', 'SCHEMA', N'catalog', 'TABLE', N'Bundle', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'Bundle', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'Bundle', 'COLUMN', N'Id'
GO
