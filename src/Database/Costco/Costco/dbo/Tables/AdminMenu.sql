CREATE TABLE [dbo].[AdminMenu] (
    [AdminMenuId] UNIQUEIDENTIFIER CONSTRAINT [DF_AdminMenu_AdminMenuId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Label]       VARCHAR (150)    NULL,
    [DisplayFile] VARCHAR (150)    NULL,
    [ParentId]    UNIQUEIDENTIFIER NULL,
    [IsActive]    BIT              NULL,
    [Ordinal]     INT              NULL,
    [ChannelID]   INT              NULL,
    CONSTRAINT [PK_AdminMenu] PRIMARY KEY CLUSTERED ([AdminMenuId] ASC)
);

