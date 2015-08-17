CREATE TABLE [ups].[MilitaryBase]
(
[BaseId] [int] NOT NULL IDENTITY(1, 1),
[BranchId] [int] NOT NULL,
[BaseName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Kiosk] [bit] NOT NULL CONSTRAINT [DF__MilitaryB__Kiosk__559C5633] DEFAULT ((0)),
[Address1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MainNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreHours] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KioskCode] [int] NULL,
[StoreCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [ups].[MilitaryBase] ADD CONSTRAINT [PK__Military__E797087653B40DC1] PRIMARY KEY CLUSTERED  ([BaseId]) ON [PRIMARY]
GO
