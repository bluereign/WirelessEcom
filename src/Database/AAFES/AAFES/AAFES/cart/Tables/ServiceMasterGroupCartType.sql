CREATE TABLE [cart].[ServiceMasterGroupCartType] (
    [CartTypeId]             INT              NULL,
    [ServiceMasterGroupGuid] UNIQUEIDENTIFIER NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [catalog].[ServiceMasterGroup]', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'ServiceMasterGroupCartType', @level2type = N'COLUMN', @level2name = N'ServiceMasterGroupGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [cart].[CartType]', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'ServiceMasterGroupCartType', @level2type = N'COLUMN', @level2name = N'CartTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ASSOCIATION. [catalog].[ServiceMasterGroup] + [cart].[CartType]', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'ServiceMasterGroupCartType';

