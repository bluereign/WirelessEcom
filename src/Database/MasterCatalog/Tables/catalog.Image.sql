CREATE TABLE [catalog].[Image]
(
[ImageGuid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Image_ImageGuid] DEFAULT (newid()),
[ReferenceGuid] [uniqueidentifier] NULL,
[IsActive] [bit] NULL,
[IsPrimaryImage] [bit] NULL,
[Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Caption] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alt] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalHeight] [int] NULL,
[OriginalWidth] [int] NULL,
[CreatedDate] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ordinal] [int] NULL CONSTRAINT [DF_Image_Ordinal] DEFAULT ((0)),
[binImage] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [catalog].[Image] ADD CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED  ([ImageGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_catalog_Image_ReferenceGuid_Ordinal] ON [catalog].[Image] ([ReferenceGuid], [Ordinal]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'All images used on site are stored in binary in this table. It is updated from the ContentAdmin on STAGE: http://10.7.0.80:81/ContentAdmin', 'SCHEMA', N'catalog', 'TABLE', N'Image', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'25-SEP-2012', 'SCHEMA', N'catalog', 'TABLE', N'Image', 'COLUMN', N'ImageGuid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalog', 'TABLE', N'Image', 'COLUMN', N'ImageGuid'
GO
