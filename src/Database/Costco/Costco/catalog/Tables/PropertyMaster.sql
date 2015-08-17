CREATE TABLE [catalog].[PropertyMaster] (
    [PropertyMasterGuid]      UNIQUEIDENTIFIER CONSTRAINT [DF_PropertyMaster_PropertyMasterId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                   VARCHAR (150)    NULL,
    [Ordinal]                 INT              NULL,
    CONSTRAINT [PK_PropertyMaster] PRIMARY KEY CLUSTERED ([PropertyMasterGuid] ASC),
    CONSTRAINT [FK_PropertyMaster_PropertyMasterGroup] FOREIGN KEY ([PropertyMasterGroupGuid]) REFERENCES [catalog].[PropertyMasterGroup] ([PropertyMasterGroupGuid])
);

