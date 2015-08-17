CREATE TABLE [catalog].[Image] (
    [ImageGuid]      UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
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
    [Ordinal]        INT              NULL,
    [binImage]       IMAGE            NULL
);

