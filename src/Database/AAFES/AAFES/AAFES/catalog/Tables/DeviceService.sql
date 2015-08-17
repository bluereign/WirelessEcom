CREATE TABLE [catalog].[DeviceService] (
    [DeviceGuid]  UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid] UNIQUEIDENTIFIER NOT NULL,
    [IsDefault]   BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DeviceService] PRIMARY KEY CLUSTERED ([DeviceGuid] ASC, [ServiceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_DeviceService_Device] FOREIGN KEY ([DeviceGuid]) REFERENCES [catalog].[Device] ([DeviceGuid]),
    CONSTRAINT [FK_DeviceService_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
);


GO
ALTER TABLE [catalog].[DeviceService] NOCHECK CONSTRAINT [FK_DeviceService_Device];


GO
CREATE NONCLUSTERED INDEX [IX_ServiceGuid_DeviceGuid]
    ON [catalog].[DeviceService]([ServiceGuid] ASC, [DeviceGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [catalog].[Service] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceService', @level2type = N'COLUMN', @level2name = N'ServiceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceService', @level2type = N'COLUMN', @level2name = N'ServiceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to [catalog].[Device] table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceService', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceService', @level2type = N'COLUMN', @level2name = N'DeviceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [catalog].[Device] + [catalog].[Service]', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'DeviceService';

