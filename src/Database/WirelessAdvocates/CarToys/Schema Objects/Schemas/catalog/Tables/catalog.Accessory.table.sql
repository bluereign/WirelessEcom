CREATE TABLE [catalog].[Accessory] (
    [AccessoryGuid]    UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              CHAR (12)        NOT NULL,
    [Name]             NVARCHAR (67)    NOT NULL
);

