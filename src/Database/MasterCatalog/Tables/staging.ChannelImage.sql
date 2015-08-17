CREATE TABLE [staging].[ChannelImage]
(
[ImageGuid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Image_ImageGuidChan] DEFAULT (newid()),
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
[Ordinal] [int] NULL CONSTRAINT [DF_Image_OrdinalChn] DEFAULT ((0)),
[binImage] [image] NULL,
[ChannelId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [staging].[ChannelImage] ADD CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED  ([ImageGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
