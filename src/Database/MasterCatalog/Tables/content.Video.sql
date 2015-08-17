CREATE TABLE [content].[Video]
(
[VideoId] [int] NOT NULL IDENTITY(1, 1),
[ProductId] [int] NULL,
[FileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PosterFileName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_Video_Active] DEFAULT ((1)),
[Ordinal] [int] NOT NULL CONSTRAINT [DF_Video_Ordinal] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [content].[Video] ADD CONSTRAINT [PK__Video__BAE5126A52936A51] PRIMARY KEY CLUSTERED  ([VideoId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'content', 'TABLE', N'Video', 'COLUMN', N'VideoId'
GO
