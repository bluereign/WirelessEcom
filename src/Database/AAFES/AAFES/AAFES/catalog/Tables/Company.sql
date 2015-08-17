CREATE TABLE [catalog].[Company] (
    [CompanyGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Company_CompanyGuid] DEFAULT (newid()) NOT NULL,
    [CompanyName] NVARCHAR (30)    NOT NULL,
    [IsCarrier]   BIT              CONSTRAINT [DF_Company_IsCarrier] DEFAULT ((0)) NOT NULL,
    [CarrierId]   INT              NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED ([CompanyGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Company]
    ON [catalog].[Company]([CompanyGuid] ASC) WITH (FILLFACTOR = 80);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Only assigned to carriers.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indicates if the company name is a cell phone carrier.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'IsCarrier';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'IsCarrier';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The name of the carrier or accessory/kit company.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CompanyName';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CompanyName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CompanyGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'20-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company', @level2type = N'COLUMN', @level2name = N'CompanyGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'List of carriers and device/accessory manufacturer names.', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Company';

