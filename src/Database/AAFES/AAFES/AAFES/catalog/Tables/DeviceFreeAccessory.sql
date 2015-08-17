CREATE TABLE [catalog].[DeviceFreeAccessory] (
    [DeviceFreeAccessoryGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_DeviceFreeAccessory_DeviceFreeAccessoryGuid] DEFAULT (newid()) NOT NULL,
    [DeviceGuid]              UNIQUEIDENTIFIER NOT NULL,
    [ProductGuid]             UNIQUEIDENTIFIER NOT NULL,
    [StartDate]               DATETIME         NOT NULL,
    [EndDate]                 DATETIME         NOT NULL,
    CONSTRAINT [PK_DeviceFreeAccessory] PRIMARY KEY CLUSTERED ([DeviceFreeAccessoryGuid] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Product]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'ModifiedDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'Should be FK', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'ProductGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Device]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'ModifiedDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'Should be FK', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceFreeAccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Should be the PK', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceFreeAccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'ModifiedDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceFreeAccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceFreeAccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'Should be PK', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory', @level2type = N'COLUMN', @level2name = N'DeviceFreeAccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. Devices and accessories that are not kits. KIT ASSOCIATIONS SHOULD NOT BE IN THIS TABLE.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceFreeAccessory';

