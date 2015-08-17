CREATE TABLE [catalog].[GersItm] (
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
    [UPC]                  NVARCHAR (12) NULL,
    [isManual]             BIT           CONSTRAINT [DF_GersItm_isManual] DEFAULT ((0)) NOT NULL,
    [isPreventSale]        BIT           CONSTRAINT [DF_GersItm_isPreventSale] DEFAULT ((0)) NOT NULL,
    [isDeleted]            BIT           CONSTRAINT [DF_GersItm_isDeleted] DEFAULT ((0)) NOT NULL,
    [InsertDate]           DATETIME      CONSTRAINT [DF_GersItm_InsertDate] DEFAULT (getdate()) NOT NULL,
    [Finish]               NVARCHAR (30) NULL,
    CONSTRAINT [PK_GersItm] PRIMARY KEY CLUSTERED ([GersSku] ASC)
);

