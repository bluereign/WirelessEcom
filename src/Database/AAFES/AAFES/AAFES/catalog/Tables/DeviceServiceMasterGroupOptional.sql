CREATE TABLE [catalog].[DeviceServiceMasterGroupOptional] (
    [DeviceGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_DeviceServiceMasterGroupOptional] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key, also FK, links to [catalog].[Device]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceServiceMasterGroupOptional', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceServiceMasterGroupOptional', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. TABLES CONNECTED AND PURPOSE IS UNKNOWN.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceServiceMasterGroupOptional';

