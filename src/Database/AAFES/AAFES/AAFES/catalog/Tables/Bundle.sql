CREATE TABLE [catalog].[Bundle] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]      VARCHAR (50)   NULL,
    [Bundle]    TEXT           NULL,
    [CreatedBy] VARCHAR (50)   NULL,
    [CreatedOn] DATETIME       NULL,
    [Active]    BIT            NULL,
    [BundleXml] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Bundle] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Bundle', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Bundle', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DELETION IN PROGRESS??? Currently not in use.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Bundle';

