CREATE TABLE [catalog].[Property] (
    [PropertyGuid]     UNIQUEIDENTIFIER CONSTRAINT [DF_ProductProperty_PropertyId] DEFAULT (newid()) NOT NULL,
    [ProductGuid]      UNIQUEIDENTIFIER NULL,
    [IsCustom]         BIT              NULL,
    [LastModifiedDate] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (50)    NULL,
    [Name]             NVARCHAR (50)    NULL,
    [Value]            NVARCHAR (MAX)   NULL,
    [Active]           BIT              CONSTRAINT [DF__Property__Active__07ECDD10] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([PropertyGuid] ASC),
    CONSTRAINT [uc_propertyproductguidname] UNIQUE NONCLUSTERED ([ProductGuid] ASC, [Name] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCL_catalog_property_productGUID_Name]
    ON [catalog].[Property]([ProductGuid] ASC, [Name] ASC)
    INCLUDE([Value]) WITH (DATA_COMPRESSION = PAGE);


GO
CREATE NONCLUSTERED INDEX [IDX_Property_PAN]
    ON [catalog].[Property]([ProductGuid] ASC, [Active] ASC, [Name] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_Property_NAPP]
    ON [catalog].[Property]([Name] ASC, [Active] ASC, [ProductGuid] ASC, [PropertyGuid] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_Property_NPI]
    ON [catalog].[Property]([Name] ASC, [ProductGuid] ASC, [IsCustom] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_Property_NPP]
    ON [catalog].[Property]([Name] ASC, [ProductGuid] ASC, [PropertyGuid] ASC)
    INCLUDE([Value]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IDX_Property]
    ON [catalog].[Property]([Name] ASC, [ProductGuid] ASC, [PropertyGuid] ASC)
    INCLUDE([IsCustom], [Value], [Active]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Name_ProductGuid]
    ON [catalog].[Property]([Name] ASC, [ProductGuid] ASC) WITH (FILLFACTOR = 90);


GO
CREATE STATISTICS [stats_catalog_property_value]
    ON [catalog].[Property]([Value]);

