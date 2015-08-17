CREATE TABLE [logging].[EditorsChoice]
(
[EntryId] [int] NOT NULL IDENTITY(1, 1),
[StartDate] [datetime] NULL,
[ECOrder] [int] NULL,
[ProductId] [int] NULL,
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChannelId] [int] NULL
) ON [PRIMARY]
GO
