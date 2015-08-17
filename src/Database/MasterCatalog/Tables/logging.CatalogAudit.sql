CREATE TABLE [logging].[CatalogAudit]
(
[Instance] [int] NOT NULL IDENTITY(1, 1),
[Type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchemaName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PKCol] [varchar] (129) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdateDate] [datetime] NULL,
[UserName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServerName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [logging].[CatalogAudit] ADD CONSTRAINT [PK__CatalogA__842EE79117A9455B] PRIMARY KEY CLUSTERED  ([Instance]) ON [PRIMARY]
GO
