CREATE TABLE [catalog].[GersItm] (
    [GersSku]              NVARCHAR (9)  NOT NULL,
    [VendorCode]           NVARCHAR (4)  NOT NULL,
    [MajorCode]            NVARCHAR (5)  NOT NULL,
    [MinorCode]            NVARCHAR (5)  NOT NULL,
    [ItemTypeCode]         NVARCHAR (3)  NOT NULL,
    [CategoryCode]         NVARCHAR (5)  NULL,
    [VendorStockNumber]    NVARCHAR (30) NULL,
    [Description]          NVARCHAR (30) NULL,
    [DescriptionAlternate] NVARCHAR (30) NULL
);

