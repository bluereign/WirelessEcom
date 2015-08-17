CREATE TABLE [staging].[ChannelProperty]
(
[PropertyGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductProperty_ChnPropertyId] DEFAULT (newid()),
[ProductGuid] [uniqueidentifier] NULL,
[IsCustom] [bit] NULL,
[LastModifiedDate] [datetime] NULL,
[LastModifiedBy] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF__Property__ActiveChannel] DEFAULT ((1)),
[ChannelID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [staging].[ChannelProperty] ADD CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED  ([PropertyGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
