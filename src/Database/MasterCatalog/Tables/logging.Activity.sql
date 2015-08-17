CREATE TABLE [logging].[Activity]
(
[ActivityId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeReferenceId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryActivityType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Timestamp] [datetime] NOT NULL CONSTRAINT [DF__Activity__Timest__59A6EF73] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [logging].[Activity] ADD CONSTRAINT [PK__Activity__45F4A79157BEA701] PRIMARY KEY CLUSTERED  ([ActivityId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'logging', 'TABLE', N'Activity', 'COLUMN', N'ActivityId'
GO
