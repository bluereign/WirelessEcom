CREATE TABLE [content].[Multimedia]
(
[MultimediaId] [int] NOT NULL IDENTITY(1, 1),
[FileName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlayLength] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderBy] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [content].[Multimedia] ADD CONSTRAINT [PK__Multimed__35412A8918984625] PRIMARY KEY CLUSTERED  ([MultimediaId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'content', 'TABLE', N'Multimedia', 'COLUMN', N'MultimediaId'
GO
