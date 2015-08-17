CREATE TABLE [catalog].[Channel]
(
[ChannelGuid] [uniqueidentifier] NULL CONSTRAINT [DF_ChannelizeID] DEFAULT (newid()),
[ChannelId] [int] NOT NULL,
[Channel] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[Channel] ADD CONSTRAINT [PK__Channel__38C3E8145E66A65E] PRIMARY KEY CLUSTERED  ([ChannelId]) ON [PRIMARY]
GO
