CREATE TABLE [service].[IncomingGersItm] (
    [GersSku]              NVARCHAR (9)  NOT NULL,
    [VendorCode]           NVARCHAR (4)  NOT NULL,
    [MajorCode]            NVARCHAR (5)  NOT NULL,
    [MinorCode]            NVARCHAR (5)  NOT NULL,
    [ItemTypeCode]         NVARCHAR (3)  NOT NULL,
    [CategoryCode]         NVARCHAR (5)  NULL,
    [VendorStockNumber]    NVARCHAR (30) NULL,
    [Description]          NVARCHAR (30) NULL,
    [DescriptionAlternate] NVARCHAR (30) NULL,
    [DropCode]             NVARCHAR (3)  NULL,
    [DropDate]             DATE          NULL,
    [PreventSale]          NVARCHAR (1)  NOT NULL,
    [UPC]                  NVARCHAR (12) NULL,
    CONSTRAINT [PK__Incoming__315C442066C6E235] PRIMARY KEY CLUSTERED ([GersSku] ASC)
);

