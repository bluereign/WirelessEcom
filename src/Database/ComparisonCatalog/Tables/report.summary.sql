CREATE TABLE [report].[summary]
(
[Section] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastWeekTotal] [int] NULL,
[New] [int] NULL CONSTRAINT [DF_summary_New] DEFAULT ((0)),
[Removed] [int] NULL CONSTRAINT [DF_summary_Removed] DEFAULT ((0)),
[Updates] [int] NULL CONSTRAINT [DF_summary_Updates] DEFAULT ((0)),
[ThisWeekTotal] [int] NULL,
[Push] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [report].[summary] ADD CONSTRAINT [PK__summary__70E702BA2DB1C7EE] PRIMARY KEY CLUSTERED  ([Section]) ON [PRIMARY]
GO
