
CREATE TABLE [catalog].[Tablet](
	[TabletGuid] [uniqueidentifier] NOT NULL,
	[CarrierGuid] [uniqueidentifier] NOT NULL,
	[ManufacturerGuid] [uniqueidentifier] NULL,
	[UPC] [nvarchar](20) NULL,
	[Name] [nvarchar](67) NULL,
	[InsertDate] [datetime] NULL,
 CONSTRAINT [PK_Tablet] PRIMARY KEY CLUSTERED 
(
	[TabletGuid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [catalog].[Tablet] ADD  CONSTRAINT [DF_Tablet_InsertDate]  DEFAULT (getdate()) FOR [InsertDate]
GO
