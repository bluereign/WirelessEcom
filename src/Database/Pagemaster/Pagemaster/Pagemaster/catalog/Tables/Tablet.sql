CREATE TABLE [catalog].[Tablet] (
    [TabletGuid]       UNIQUEIDENTIFIER NOT NULL,
    [CarrierGuid]      UNIQUEIDENTIFIER NOT NULL,
    [ManufacturerGuid] UNIQUEIDENTIFIER NULL,
    [UPC]              NVARCHAR (20)    NULL,
    [Name]             NVARCHAR (67)    NULL,
    CONSTRAINT [PK_Tablet] PRIMARY KEY CLUSTERED ([TabletGuid] ASC) WITH (FILLFACTOR = 80)
);

