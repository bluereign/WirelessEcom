CREATE TABLE [service].[IncomingGersItm]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VendorCode] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MajorCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MinorCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemTypeCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CategoryCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorStockNumber] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DescriptionAlternate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DropCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DropDate] [date] NULL,
[PreventSale] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UPC] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [service].[IncomingGersItm] ADD CONSTRAINT [PK__Incoming__315C442066C6E235] PRIMARY KEY CLUSTERED  ([GersSku]) ON [PRIMARY]
GO
