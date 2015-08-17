CREATE TABLE [catalog].[PropertyMaster] (
    [PropertyMasterGuid]      UNIQUEIDENTIFIER CONSTRAINT [DF_PropertyMaster_PropertyMasterId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                   VARCHAR (150)    NULL,
    [Ordinal]                 INT              NULL,
    CONSTRAINT [PK_PropertyMaster] PRIMARY KEY CLUSTERED ([PropertyMasterGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PropertyMaster_PropertyMasterGroup] FOREIGN KEY ([PropertyMasterGroupGuid]) REFERENCES [catalog].[PropertyMasterGroup] ([PropertyMasterGroupGuid])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to PropertyMasterGroup table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'PropertyMaster', @level2type = N'COLUMN', @level2name = N'PropertyMasterGroupGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'PropertyMaster', @level2type = N'COLUMN', @level2name = N'PropertyMasterGuid';

