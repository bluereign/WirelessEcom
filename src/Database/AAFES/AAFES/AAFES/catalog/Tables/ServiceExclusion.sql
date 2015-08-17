CREATE TABLE [catalog].[ServiceExclusion] (
    [ParentGuid]  UNIQUEIDENTIFIER NOT NULL,
    [ServiceGuid] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_ServiceExclusion] PRIMARY KEY CLUSTERED ([ParentGuid] ASC, [ServiceGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ServiceExclusion_ProductGuid] FOREIGN KEY ([ParentGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid]),
    CONSTRAINT [FK_ServiceExclusion_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to Service table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ServiceExclusion', @level2type = N'COLUMN', @level2name = N'ServiceGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to ProductGuid table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ServiceExclusion', @level2type = N'COLUMN', @level2name = N'ParentGuid';

