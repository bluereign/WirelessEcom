CREATE TABLE [catalog].[PropertyMasterAlias] (
    [PropertyMasterAliasGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_PropertyMasterAlias_PropertyMasterAliasGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [PropertyMasterGuid]      UNIQUEIDENTIFIER NULL,
    [CarrierPropertyName]     VARCHAR (50)     NULL,
    CONSTRAINT [PK_PropertyMasterAlias] PRIMARY KEY CLUSTERED ([PropertyMasterAliasGuid] ASC),
    CONSTRAINT [FK_PropertyMasterAlias_PropertyMaster] FOREIGN KEY ([PropertyMasterGuid]) REFERENCES [catalog].[PropertyMaster] ([PropertyMasterGuid])
);

