CREATE TABLE [cart].[CartType] (
    [CartTypeId]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (100) NULL,
    [ParentCartTypeId] INT           NULL,
    PRIMARY KEY CLUSTERED ([CartTypeId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sub-key for different scenarios under the main cart type.', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'CartType', @level2type = N'COLUMN', @level2name = N'ParentCartTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'CartType', @level2type = N'COLUMN', @level2name = N'ParentCartTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'CartType', @level2type = N'COLUMN', @level2name = N'CartTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'CartType', @level2type = N'COLUMN', @level2name = N'CartTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cart type indicates New Activation versus Upgrade versus Add-A-Line, etc.', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'CartType';

