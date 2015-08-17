CREATE TABLE [test].[BulkLoadPropertyBackup] (
    [PropertyGuid]     UNIQUEIDENTIFIER NOT NULL,
    [ProductGuid]      UNIQUEIDENTIFIER NULL,
    [IsCustom]         BIT              NULL,
    [LastModifiedDate] DATETIME         NULL,
    [LastModifiedBy]   NVARCHAR (50)    NULL,
    [Name]             NVARCHAR (50)    NULL,
    [Value]            NVARCHAR (MAX)   NULL,
    [Active]           BIT              NULL
);

