CREATE TABLE [dbo].[Device]
(
[DeviceGuid] [uniqueidentifier] NOT NULL,
[CarrierGuid] [uniqueidentifier] NOT NULL,
[ManufacturerGuid] [uniqueidentifier] NOT NULL,
[UPC] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
