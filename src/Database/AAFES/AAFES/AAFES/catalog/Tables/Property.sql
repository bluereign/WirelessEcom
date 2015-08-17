CREATE TABLE [catalog].[Property] (
    [PropertyGuid]     UNIQUEIDENTIFIER CONSTRAINT [DF_ProductProperty_PropertyId] DEFAULT (newid()) NOT NULL,
    [ProductGuid]      UNIQUEIDENTIFIER NULL,
    [IsCustom]         BIT              NULL,
    [LastModifiedDate] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (50)    NULL,
    [Name]             NVARCHAR (50)    NULL,
    [Value]            NVARCHAR (MAX)   NULL,
    [Active]           BIT              CONSTRAINT [DF__Property__Active__07ECDD10] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([PropertyGuid] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [uc_propertyproductguidname] UNIQUE NONCLUSTERED ([ProductGuid] ASC, [Name] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ix_Property_ProductGuid]
    ON [catalog].[Property]([ProductGuid] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Name_ProductGuid]
    ON [catalog].[Property]([Name] ASC, [ProductGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Property', @level2type = N'COLUMN', @level2name = N'PropertyGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The property table ', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Property';

