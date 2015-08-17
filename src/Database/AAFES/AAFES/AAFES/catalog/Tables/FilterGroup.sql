CREATE TABLE [catalog].[FilterGroup] (
    [FilterGroupId]       INT           IDENTITY (1, 1) NOT NULL,
    [ProductType]         VARCHAR (50)  NOT NULL,
    [Label]               VARCHAR (100) NOT NULL,
    [FieldName]           VARCHAR (100) NOT NULL,
    [AllowSelectMultiple] INT           NOT NULL,
    [Ordinal]             INT           NOT NULL,
    [Active]              INT           NOT NULL,
    CONSTRAINT [PK_FilterGroup] PRIMARY KEY CLUSTERED ([FilterGroupId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Whether the category should appear (1) on the site or not appear (0).', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Active';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Active';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order the filter appears.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Ordinal';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Ordinal';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Box (1) versus radial (0) selection on the site.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'AllowSelectMultiple';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'AllowSelectMultiple';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Same as Label, but formatted for coding purposes.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'FieldName';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'FieldName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of the category', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Label';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'Label';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What belongs in the filter: phone
plan
accessory
datacardandnetbook
prepaid', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'ProductType';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'ProductType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key for table.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'FilterGroupId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup', @level2type = N'COLUMN', @level2name = N'FilterGroupId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lists categories for the filters. This complements the [catalog].[FilterOption] table.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'FilterGroup';

