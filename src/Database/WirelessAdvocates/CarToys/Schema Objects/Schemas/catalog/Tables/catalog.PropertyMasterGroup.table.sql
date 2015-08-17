CREATE TABLE [catalog].[PropertyMasterGroup] (
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [ProductType]             VARCHAR (50)     NULL,
    [PropertyType]            VARCHAR (50)     NULL,
    [Label]                   VARCHAR (50)     NULL,
    [Ordinal]                 INT              NULL
);

