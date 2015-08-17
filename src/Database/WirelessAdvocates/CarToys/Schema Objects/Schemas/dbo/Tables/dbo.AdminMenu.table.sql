CREATE TABLE [dbo].[AdminMenu] (
    [AdminMenuId] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [Label]       VARCHAR (150)    NULL,
    [DisplayFile] VARCHAR (150)    NULL,
    [ParentId]    UNIQUEIDENTIFIER NULL,
    [IsActive]    BIT              NULL,
    [Ordinal]     INT              NULL
);

