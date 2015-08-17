CREATE TABLE [catalog].[PropertyMaster] (
    [PropertyMasterGuid]      UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                   VARCHAR (150)    NULL,
    [Ordinal]                 INT              NULL
);

