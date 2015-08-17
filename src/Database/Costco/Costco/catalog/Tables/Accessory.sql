CREATE TABLE [catalog].[Accessory] (
    [AccessoryGuid]    UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (30)    NULL,
    [Name]             NVARCHAR (67)    NOT NULL,
    CONSTRAINT [PK_Accessory] PRIMARY KEY CLUSTERED ([AccessoryGuid] ASC)
);

