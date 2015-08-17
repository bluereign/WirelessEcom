CREATE TABLE [service].[Authorize]
(
[AuthID] [int] NOT NULL IDENTITY(1, 1),
[OrderId] [int] NOT NULL,
[SCN] [varbinary] (128) NOT NULL,
[Amount] [money] NOT NULL,
[ApprovedDate] [datetime] NULL,
[SettledDate] [datetime] NULL,
[CreditedDate] [datetime] NULL,
[AuthCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthTicket] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IPAddress] [varchar] (39) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChannelID] [int] NOT NULL,
[Transaction] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [service].[Authorize] ADD CONSTRAINT [PK__Authoriz__12C15D33DE13DBA5] PRIMARY KEY CLUSTERED  ([AuthID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_SelectAll] ON [service].[Authorize] ([AuthID], [OrderId], [Amount], [ApprovedDate], [SettledDate], [CreditedDate], [AuthCode], [AuthTicket], [IPAddress], [ChannelID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_OrderId] ON [service].[Authorize] ([OrderId]) ON [PRIMARY]
GO
ALTER TABLE [service].[Authorize] ADD CONSTRAINT [FK__Authorize__Chann__239E4DCF] FOREIGN KEY ([ChannelID]) REFERENCES [catalog].[Channel] ([ChannelId])
GO
