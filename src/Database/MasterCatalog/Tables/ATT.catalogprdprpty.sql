CREATE TABLE [ATT].[catalogprdprpty]
(
[prpty_Id] [int] NULL,
[prd_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
