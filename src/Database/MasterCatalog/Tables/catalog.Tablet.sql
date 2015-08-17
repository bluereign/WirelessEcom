CREATE TABLE [catalog].[Tablet]
(
[TabletGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[ManufacturerGuid] [uniqueidentifier] NULL,
[UPC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (67) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF_Tablet_InsertDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[Tablet] ADD CONSTRAINT [PK_Tablet] PRIMARY KEY CLUSTERED  ([TabletGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
