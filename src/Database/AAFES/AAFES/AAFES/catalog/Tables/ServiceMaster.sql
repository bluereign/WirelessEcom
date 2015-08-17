CREATE TABLE [catalog].[ServiceMaster] (
    [ServiceMasterGuid]      UNIQUEIDENTIFIER CONSTRAINT [DF_ServiceMaster_ServiceMasterId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ServiceMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                  VARCHAR (150)    NULL,
    [ServiceGUID]            UNIQUEIDENTIFIER NULL,
    [Ordinal]                INT              NULL,
    CONSTRAINT [PK_ServiceMaster] PRIMARY KEY CLUSTERED ([ServiceMasterGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ServiceMaster_ServiceMasterGroup] FOREIGN KEY ([ServiceMasterGroupGuid]) REFERENCES [catalog].[ServiceMasterGroup] ([ServiceMasterGroupGuid])
);


GO
CREATE NONCLUSTERED INDEX [IX_ServiceManagerGroupLookups]
    ON [catalog].[ServiceMaster]([ServiceMasterGroupGuid] ASC, [ServiceGUID] ASC, [Label] ASC, [ServiceMasterGuid] ASC, [Ordinal] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Link to ServiceMasterGroup table', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ServiceMaster', @level2type = N'COLUMN', @level2name = N'ServiceMasterGroupGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'ServiceMaster', @level2type = N'COLUMN', @level2name = N'ServiceMasterGuid';

