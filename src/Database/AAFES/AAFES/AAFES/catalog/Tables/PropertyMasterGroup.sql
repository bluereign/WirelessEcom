CREATE TABLE [catalog].[PropertyMasterGroup] (
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Table_1_PropertyMasterGroupId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ProductType]             VARCHAR (50)     NULL,
    [PropertyType]            VARCHAR (50)     NULL,
    [Label]                   VARCHAR (50)     NULL,
    [Ordinal]                 INT              NULL,
    CONSTRAINT [PK_PropertyMasterGroup] PRIMARY KEY CLUSTERED ([PropertyMasterGroupGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'PropertyMasterGroup', @level2type = N'COLUMN', @level2name = N'PropertyMasterGroupGuid';

