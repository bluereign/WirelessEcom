CREATE TABLE [logging].[DataPush]
(
[PushId] [int] NOT NULL IDENTITY(1, 1),
[Timestamp] [datetime] NOT NULL CONSTRAINT [DP_Timestamp] DEFAULT (getdate()),
[Pushed] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
