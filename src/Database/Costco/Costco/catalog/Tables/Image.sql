﻿CREATE TABLE [catalog].[Image] (
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
    CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED ([ImageGuid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCL_catalog_Image_IsPrimaryImage_ReferenceGUID]
    ON [catalog].[Image]([IsPrimaryImage] ASC, [ReferenceGuid] ASC)
    INCLUDE([ImageGuid], [IsActive], [Title], [Caption], [Alt], [OriginalHeight], [OriginalWidth], [Ordinal]);


GO
CREATE NONCLUSTERED INDEX [IX_catalog_Image_ReferenceGuid_Ordinal]
    ON [catalog].[Image]([ReferenceGuid] ASC, [Ordinal] ASC);

