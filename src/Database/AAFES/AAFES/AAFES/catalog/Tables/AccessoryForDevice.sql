CREATE TABLE [catalog].[AccessoryForDevice] (
    [DeviceGuid]    UNIQUEIDENTIFIER NOT NULL,
    [AccessoryGuid] UNIQUEIDENTIFIER NOT NULL,
    [Ordinal]       INT              CONSTRAINT [DF_OrderOne] DEFAULT ('1') NOT NULL,
    CONSTRAINT [uq_DeviceAccessoryCombo] UNIQUE NONCLUSTERED ([DeviceGuid] ASC, [AccessoryGuid] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Device] or [catalog].[Product] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice', @level2type = N'COLUMN', @level2name = N'AccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice', @level2type = N'COLUMN', @level2name = N'AccessoryGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[Device] or [catalog].[Product] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'ModifiedDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [catalog].[Accessory] + [catalog].[Device] KITS SHOULD BE IN THIS TABLE.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'AccessoryForDevice';

