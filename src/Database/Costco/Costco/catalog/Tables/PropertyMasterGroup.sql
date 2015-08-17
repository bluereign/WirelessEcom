CREATE TABLE [catalog].[PropertyMasterGroup] (
    [PropertyMasterGroupGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Table_1_PropertyMasterGroupId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ProductType]             VARCHAR (50)     NULL,
    [PropertyType]            VARCHAR (50)     NULL,
    [Label]                   VARCHAR (50)     NULL,
    [Ordinal]                 INT              NULL,
    CONSTRAINT [PK_PropertyMasterGroup] PRIMARY KEY CLUSTERED ([PropertyMasterGroupGuid] ASC)
);

