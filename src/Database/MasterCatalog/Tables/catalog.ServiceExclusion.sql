CREATE TABLE [catalog].[ServiceExclusion]
(
[ParentGuid] [uniqueidentifier] NOT NULL,
[ServiceGuid] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
ALTER TABLE [catalog].[ServiceExclusion] WITH NOCHECK ADD
CONSTRAINT [FK_ServiceExclusion_Service] FOREIGN KEY ([ServiceGuid]) REFERENCES [catalog].[Service] ([ServiceGuid])
GO
ALTER TABLE [catalog].[ServiceExclusion] ADD CONSTRAINT [PK_ServiceExclusion] PRIMARY KEY CLUSTERED  ([ParentGuid], [ServiceGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [catalog].[ServiceExclusion] WITH NOCHECK ADD CONSTRAINT [FK_ServiceExclusion_ProductGuid] FOREIGN KEY ([ParentGuid]) REFERENCES [catalog].[ProductGuid] ([ProductGuid])
GO

EXEC sp_addextendedproperty N'MS_Description', N'Link to ProductGuid table', 'SCHEMA', N'catalog', 'TABLE', N'ServiceExclusion', 'COLUMN', N'ParentGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link to Service table', 'SCHEMA', N'catalog', 'TABLE', N'ServiceExclusion', 'COLUMN', N'ServiceGuid'
GO
