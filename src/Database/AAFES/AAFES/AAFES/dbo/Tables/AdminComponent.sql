CREATE TABLE [dbo].[AdminComponent] (
    [AdminComponentId] UNIQUEIDENTIFIER CONSTRAINT [DF_AdminComponent_AdminComponentId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [AdminMenuId]      UNIQUEIDENTIFIER NULL,
    [Component]        VARCHAR (50)     NULL,
    [Title]            VARCHAR (50)     NULL,
    [Ordinal]          INT              NULL,
    CONSTRAINT [PK_AdminComponent] PRIMARY KEY CLUSTERED ([AdminComponentId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AdminComponent', @level2type = N'COLUMN', @level2name = N'AdminComponentId';

