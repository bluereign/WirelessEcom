CREATE TABLE [catalog].[ProducttoParentChannel]
(
[ProducttoParentGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProducttoParentGuid] DEFAULT (newsequentialid()),
[ProductGuid] [uniqueidentifier] NOT NULL,
[ParentProductGuid] [uniqueidentifier] NOT NULL,
[ChannelId] [int] NULL
) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_476305623_3_2] ON [catalog].[ProducttoParentChannel] ([ParentProductGuid], [ProductGuid])

GO
ALTER TABLE [catalog].[ProducttoParentChannel] ADD CONSTRAINT [PK_PTPGuid] PRIMARY KEY NONCLUSTERED  ([ProducttoParentGuid]) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [CIX_ProducttoParent] ON [catalog].[ProducttoParentChannel] ([ProducttoParentGuid]) ON [PRIMARY]
GO
