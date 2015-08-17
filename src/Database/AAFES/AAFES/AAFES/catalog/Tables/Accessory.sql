CREATE TABLE [catalog].[Accessory] (
    [AccessoryGuid]    UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (30)    NULL,
    [Name]             NVARCHAR (67)    NOT NULL,
    CONSTRAINT [PK_Accessory] PRIMARY KEY CLUSTERED ([AccessoryGuid] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of accessory provided by carrier.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'Name';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Company] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'ManufacturerGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'ManufacturerGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'AccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory', @level2type = N'COLUMN', @level2name = N'AccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of accessories along with manufacturer ID information.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Accessory';

