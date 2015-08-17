CREATE TABLE [dbo].[SharepointAccessoryImport]
(
[ProductId] [int] NOT NULL,
[ProductGuid] [uniqueidentifier] NOT NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
