CREATE TABLE [dbo].[SharepointTagsImport]
(
[ProductGuid] [uniqueidentifier] NOT NULL,
[Tag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetTag] [bit] NULL
) ON [PRIMARY]
GO
