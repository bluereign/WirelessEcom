CREATE TABLE [dbo].[AdminComponent] (
    [AdminComponentId] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [AdminMenuId]      UNIQUEIDENTIFIER NULL,
    [Component]        VARCHAR (50)     NULL,
    [Title]            VARCHAR (50)     NULL,
    [Ordinal]          INT              NULL
);

