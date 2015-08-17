CREATE TABLE [catalog].[PropertyMasterAlias] (
    [PropertyMasterAliasGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_PropertyMasterAlias_PropertyMasterAliasGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [PropertyMasterGuid]      UNIQUEIDENTIFIER NULL,
    [CarrierPropertyName]     VARCHAR (50)     NULL,
    CONSTRAINT [PK_PropertyMasterAlias] PRIMARY KEY CLUSTERED ([PropertyMasterAliasGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PropertyMasterAlias_PropertyMaster] FOREIGN KEY ([PropertyMasterGuid]) REFERENCES [catalog].[PropertyMaster] ([PropertyMasterGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to PropertyMaster table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'PropertyMasterAlias', @level2type = N'COLUMN', @level2name = N'PropertyMasterGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'PropertyMasterAlias', @level2type = N'COLUMN', @level2name = N'PropertyMasterAliasGuid';

