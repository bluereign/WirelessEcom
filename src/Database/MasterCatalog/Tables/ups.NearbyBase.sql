CREATE TABLE [ups].[NearbyBase]
(
[EntryId] [int] NOT NULL IDENTITY(1, 1),
[BranchId] [int] NOT NULL,
[KioskCode] [int] NOT NULL,
[SearchTerm] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaseName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompleteName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateDate] [date] NOT NULL,
[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
