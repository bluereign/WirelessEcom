CREATE TABLE [dbo].[AdminMenu] (
    [AdminMenuId] UNIQUEIDENTIFIER CONSTRAINT [DF_AdminMenu_AdminMenuId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Label]       VARCHAR (150)    NULL,
    [DisplayFile] VARCHAR (150)    NULL,
    [ParentId]    UNIQUEIDENTIFIER NULL,
    [IsActive]    BIT              NULL,
    [Ordinal]     INT              NULL,
    [ChannelID]   INT              NULL,
    CONSTRAINT [PK_AdminMenu] PRIMARY KEY CLUSTERED ([AdminMenuId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AdminMenu', @level2type = N'COLUMN', @level2name = N'AdminMenuId';

