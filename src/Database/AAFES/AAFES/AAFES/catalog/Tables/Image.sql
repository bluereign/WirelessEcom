CREATE TABLE [catalog].[Image] (
    [ImageGuid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Image_ImageGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [ReferenceGuid]  UNIQUEIDENTIFIER NULL,
    [IsActive]       BIT              NULL,
    [IsPrimaryImage] BIT              NULL,
    [Title]          VARCHAR (250)    NULL,
    [Caption]        VARCHAR (1000)   NULL,
    [Alt]            VARCHAR (250)    NULL,
    [OriginalHeight] INT              NULL,
    [OriginalWidth]  INT              NULL,
    [CreatedDate]    DATETIME         NULL,
    [CreatedBy]      VARCHAR (50)     NULL,
    [Ordinal]        INT              CONSTRAINT [DF_Image_Ordinal] DEFAULT ((0)) NULL,
    [binImage]       IMAGE            NULL,
    CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED ([ImageGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IX_catalog_Image_ReferenceGuid_Ordinal]
    ON [catalog].[Image]([ReferenceGuid] ASC, [Ordinal] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Image', @level2type = N'COLUMN', @level2name = N'ImageGuid';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'25-SEP-2012', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Image', @level2type = N'COLUMN', @level2name = N'ImageGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'All images used on site are stored in binary in this table. It is updated from the ContentAdmin on STAGE: http://10.7.0.80:81/ContentAdmin', @level0type = N'SCHEMA', @level0name = N'catalog', @level1type = N'TABLE', @level1name = N'Image';

