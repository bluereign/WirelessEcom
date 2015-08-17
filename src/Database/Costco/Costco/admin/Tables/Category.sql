CREATE TABLE [admin].[Category] (
    [CategoryId] INT          IDENTITY (1, 1) NOT NULL,
    [Category]   VARCHAR (50) NOT NULL,
    [Active]     BIT          DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Category', @level2type = N'COLUMN', @level2name = N'CategoryId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Category', @level2type = N'COLUMN', @level2name = N'CategoryId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of categories an action type is found under.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'Category';

