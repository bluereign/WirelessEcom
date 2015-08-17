﻿CREATE TABLE [catalog].[DeviceDetail] (
    [DeviceGuid]               UNIQUEIDENTIFIER NOT NULL,
    [ProductId]                INT              NULL,
    [GersSku]                  NVARCHAR (9)     NULL,
    [PageTitle]                NVARCHAR (1000)  NULL,
    [SummaryTitle]             NVARCHAR (500)   NULL,
    [DetailTitle]              NVARCHAR (500)   NULL,
    [CarrierId]                INT              NOT NULL,
    [CarrierName]              NVARCHAR (30)    NOT NULL,
    [ManufacturerGUID]         UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerName]         NVARCHAR (30)    NOT NULL,
    [BFreeAccessory]           INT              NULL,
    [SummaryDescription]       VARCHAR (4000)   NULL,
    [DetailDescription]        VARCHAR (MAX)    NULL,
    [MetaKeywords]             VARCHAR (4000)   NULL,
    [MetaDescription]          VARCHAR (4000)   NULL,
    [ReleaseDate]              DATE             NULL,
    [TypeId]                   INT              NULL,
    [UPC]                      NVARCHAR (20)    NULL,
    [BuyURL]                   NVARCHAR (512)   NULL,
    [ImageURL]                 NVARCHAR (512)   NULL,
    [RetailPrice]              MONEY            NULL,
    [NewPrice]                 MONEY            NULL,
    [UpgradePrice]             MONEY            NULL,
    [AddALinePrice]            MONEY            NULL,
    [NoContractPrice]          MONEY            NULL,
    [NewPriceAfterRebate]      MONEY            NULL,
    [UpgradePriceAfterRebate]  MONEY            NULL,
    [AddALinePriceAfterRebate] MONEY            NULL,
    [DefaultSortRank]          FLOAT (53)       NULL,
    [Active]                   BIT              CONSTRAINT [DF_catalog_DeviceDetail_Active] DEFAULT ((1)) NULL,
    [Prepaid]                  BIT              CONSTRAINT [DF_catalog_DeviceDetail_Prepaid] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_catalog_DeviceDetail] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC)
);

