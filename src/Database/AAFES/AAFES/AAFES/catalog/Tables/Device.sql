CREATE TABLE [catalog].[Device] (
    [DeviceGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (20)    NULL,
    [Name]             NVARCHAR (67)    NULL,
    CONSTRAINT [PK_Device] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [IX_Device_UniqueUPCByManufacturer] UNIQUE NONCLUSTERED ([UPC] ASC, [ManufacturerGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of device provided by carrier.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identifier from carrier.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'UPC';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'UPC';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Company].[CompanyGuid]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'ManufacturerGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'ManufacturerGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Company].[CompanyGuid]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'CarrierGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'CarrierGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tells what carrier each device should sell under. Also indicates the manufacturer of the device.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Device';

