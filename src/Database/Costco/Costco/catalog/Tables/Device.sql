CREATE TABLE [catalog].[Device] (
    [DeviceGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (20)    NULL,
    [Name]             NVARCHAR (67)    NOT NULL,
    CONSTRAINT [PK_Device] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC),
    CONSTRAINT [IX_Device_UniqueUPCByManufacturer] UNIQUE NONCLUSTERED ([UPC] ASC, [ManufacturerGuid] ASC)
);

