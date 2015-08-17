CREATE TABLE [ATT].[Load_Device]
(
[DeviceGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[ManufacturerGuid] [uniqueidentifier] NULL,
[UPC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (67) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [ATT].[Load_Device] ADD CONSTRAINT [PK_LoadDevice] PRIMARY KEY CLUSTERED  ([DeviceGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
