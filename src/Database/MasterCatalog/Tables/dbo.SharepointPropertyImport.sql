CREATE TABLE [dbo].[SharepointPropertyImport]
(
[ProductId] [int] NULL,
[ProductGuid] [uniqueidentifier] NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
