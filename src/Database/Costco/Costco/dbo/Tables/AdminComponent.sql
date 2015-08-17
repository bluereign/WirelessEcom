CREATE TABLE [dbo].[AdminComponent] (
    [AdminComponentId] UNIQUEIDENTIFIER CONSTRAINT [DF_AdminComponent_AdminComponentId] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [AdminMenuId]      UNIQUEIDENTIFIER NULL,
    [Component]        VARCHAR (50)     NULL,
    [Title]            VARCHAR (50)     NULL,
    [Ordinal]          INT              NULL,
    CONSTRAINT [PK_AdminComponent] PRIMARY KEY CLUSTERED ([AdminComponentId] ASC)
);

