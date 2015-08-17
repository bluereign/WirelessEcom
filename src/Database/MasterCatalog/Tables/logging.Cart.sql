CREATE TABLE [logging].[Cart]
(
[ActivityId] [int] NOT NULL IDENTITY(1, 1),
[CFIDCFTOKEN] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [int] NULL CONSTRAINT [DF__Cart__UserId__18639B60] DEFAULT ((0)),
[Path] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductIDList] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemCount] [int] NULL,
[Timestamp] [datetime] NOT NULL CONSTRAINT [DF__Cart__Timestamp__176F7727] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [logging].[Cart] ADD CONSTRAINT [PK__Cart__45F4A79115872EB5] PRIMARY KEY CLUSTERED  ([ActivityId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'logging', 'TABLE', N'Cart', 'COLUMN', N'ActivityId'
GO
