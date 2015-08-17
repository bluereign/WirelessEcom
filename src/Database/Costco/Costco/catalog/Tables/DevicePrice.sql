CREATE TABLE [catalog].[DevicePrice] (
    [DeviceGuid]               UNIQUEIDENTIFIER NOT NULL,
    [RetailPrice]              MONEY            NULL,
    [NewPrice]                 MONEY            NULL,
    [UpgradePrice]             MONEY            NULL,
    [AddALinePrice]            MONEY            NULL,
    [NoContractPrice]          MONEY            NULL,
    [NewPriceAfterRebate]      MONEY            NULL,
    [UpgradePriceAfterRebate]  MONEY            NULL,
    [AddALinePriceAfterRebate] MONEY            NULL,
    CONSTRAINT [PK_catalog_DevicePrice] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC)
);

