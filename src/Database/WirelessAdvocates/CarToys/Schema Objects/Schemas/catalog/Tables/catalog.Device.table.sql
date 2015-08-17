CREATE TABLE [catalog].[Device] (
    [DeviceGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (20)    NULL,
    [Name]             NVARCHAR (67)    NOT NULL
);

