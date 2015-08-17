CREATE TABLE [catalog].[Rebate]
(
[RebateGuid] [uniqueidentifier] NOT NULL,
[Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [money] NOT NULL,
[Active] [bit] NOT NULL,
[URL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialInstructions] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [date] NULL,
[EndDate] [date] NULL,
[RebateCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
