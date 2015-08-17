CREATE TABLE [catalog].[GersPriceGroup] (
    [PriceGroupCode]        NVARCHAR (3)  NOT NULL,
    [PriceGroupDescription] NVARCHAR (40) NOT NULL,
    CONSTRAINT [PK_GersPriceGroup] PRIMARY KEY CLUSTERED ([PriceGroupCode] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Definition of code', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersPriceGroup', @level2type = N'COLUMN', @level2name = N'PriceGroupDescription';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersPriceGroup', @level2type = N'COLUMN', @level2name = N'PriceGroupDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersPriceGroup', @level2type = N'COLUMN', @level2name = N'PriceGroupCode';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersPriceGroup', @level2type = N'COLUMN', @level2name = N'PriceGroupCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of acronyms (along with their definitions) found in the [catalog].[GersPrice] table.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'GersPriceGroup';

