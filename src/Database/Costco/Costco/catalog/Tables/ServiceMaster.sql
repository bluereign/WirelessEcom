CREATE TABLE [catalog].[ServiceMaster] (
    [ServiceMasterGuid]      UNIQUEIDENTIFIER CONSTRAINT [DF_ServiceMaster_ServiceMasterId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ServiceMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                  VARCHAR (150)    NULL,
    [ServiceGUID]            UNIQUEIDENTIFIER NULL,
    [Ordinal]                INT              NULL,
    CONSTRAINT [PK_ServiceMaster] PRIMARY KEY CLUSTERED ([ServiceMasterGuid] ASC),
    CONSTRAINT [FK_ServiceMaster_ServiceMasterGroup] FOREIGN KEY ([ServiceMasterGroupGuid]) REFERENCES [catalog].[ServiceMasterGroup] ([ServiceMasterGroupGuid])
);


GO
ALTER TABLE [catalog].[ServiceMaster] NOCHECK CONSTRAINT [FK_ServiceMaster_ServiceMasterGroup];


GO
CREATE NONCLUSTERED INDEX [IX_ServiceManagerGroupLookups]
    ON [catalog].[ServiceMaster]([ServiceMasterGroupGuid] ASC, [ServiceGUID] ASC, [Label] ASC, [ServiceMasterGuid] ASC, [Ordinal] ASC);

