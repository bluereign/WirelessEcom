CREATE TABLE [catalogthisweek].[GersItm]
(
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VendorCode] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MajorCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MinorCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemTypeCode] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CategoryCode] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorStockNumber] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DescriptionAlternate] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[GersItm] ADD CONSTRAINT [PK_GersItm] PRIMARY KEY CLUSTERED  ([GersSku]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'List of items from GERS.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of item directly from manufacturer. Our team''s catalog content analyst will clean up this value to something meaningful for the customer. The clean name is stored in the [catalog].[Property] table.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'DescriptionAlternate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Imported only so we don''t lose any data. This value is not used.', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'DescriptionAlternate'
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'DescriptionAlternate'
GO
EXEC sp_addextendedproperty N'CreateDate', N'20-SEP-2012', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'GersSku'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Links to [catalog].[Product]', 'SCHEMA', N'catalogthisweek', 'TABLE', N'GersItm', 'COLUMN', N'GersSku'
GO
