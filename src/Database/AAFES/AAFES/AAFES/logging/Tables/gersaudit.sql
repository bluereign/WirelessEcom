CREATE TABLE [logging].[gersaudit] (
    [Type]       CHAR (1)       NULL,
    [TableName]  VARCHAR (128)  NULL,
    [PK]         VARCHAR (1000) NULL,
    [FieldName]  VARCHAR (128)  NULL,
    [OldValue]   VARCHAR (1000) NULL,
    [NewValue]   VARCHAR (1000) NULL,
    [UpdateDate] DATETIME       NULL,
    [UserName]   VARCHAR (128)  NULL
);

