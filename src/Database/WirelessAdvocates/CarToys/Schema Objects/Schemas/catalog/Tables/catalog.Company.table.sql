CREATE TABLE [catalog].[Company] (
    [CompanyGuid] UNIQUEIDENTIFIER NOT NULL,
    [CompanyName] NVARCHAR (30)    NOT NULL,
    [IsCarrier]   BIT              NOT NULL,
    [CarrierId]   INT              NULL
);

