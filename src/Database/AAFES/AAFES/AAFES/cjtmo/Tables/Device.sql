CREATE TABLE [cjtmo].[Device] (
    [DeviceGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (20)    NOT NULL,
    [Name]             NVARCHAR (67)    NULL,
    [InsertDate]       DATETIME         CONSTRAINT [CJTMO_Device_CreateDate] DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([UPC] ASC)
);

