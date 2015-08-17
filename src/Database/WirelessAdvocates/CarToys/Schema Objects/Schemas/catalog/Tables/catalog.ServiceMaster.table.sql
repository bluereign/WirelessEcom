CREATE TABLE [catalog].[ServiceMaster] (
    [ServiceMasterGuid]      UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ServiceMasterGroupGuid] UNIQUEIDENTIFIER NULL,
    [Label]                  VARCHAR (150)    NULL,
    [ServiceGUID]            UNIQUEIDENTIFIER NULL,
    [Ordinal]                INT              NULL
);

