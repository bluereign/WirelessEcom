CREATE TABLE [catalogthisweek].[Property]
(
[PropertyGuid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProductProperty_PropertyId] DEFAULT (newid()),
[ProductType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierProductId] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Property__Active__07ECDD10] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [catalogthisweek].[Property] ADD CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED  ([PropertyGuid]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The property table ', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Property', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'catalogthisweek', 'TABLE', N'Property', 'COLUMN', N'PropertyGuid'
GO
