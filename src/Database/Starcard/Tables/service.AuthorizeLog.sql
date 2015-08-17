CREATE TABLE [service].[AuthorizeLog]
(
[LogId] [int] NOT NULL IDENTITY(1, 1),
[AuthID] [int] NULL,
[IncomingRequest] [datetime] NOT NULL,
[Method] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LogText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogXML] [xml] NULL,
[IPAddress] [varchar] (39) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [service].[AuthorizeLog] ADD CONSTRAINT [PK__Authoriz__5E5486487EE1028E] PRIMARY KEY CLUSTERED  ([LogId]) ON [PRIMARY]
GO
