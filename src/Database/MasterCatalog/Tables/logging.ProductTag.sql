CREATE TABLE [logging].[ProductTag]
(
[Instance] [int] NOT NULL IDENTITY(1, 1),
[Type] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProductGuid] [uniqueidentifier] NOT NULL,
[Tag] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Timestamp] [datetime] NULL CONSTRAINT [DF_ProductTag_Timestamp] DEFAULT (getdate())
) ON [PRIMARY]
GO
