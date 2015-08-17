USE [TEST.WIRELESSADVOCATES.COM]
GO

/****** Object:  Table [catalog].[ServiceDataFeature]    Script Date: 11/06/2012 09:07:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [catalog].[ServiceDataFeature](
	[ServiceDataFeatureId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceGuid] [uniqueidentifier] NOT NULL,
	[ServiceDataGroupGuid] [uniqueidentifier] NOT NULL,
	[DeviceType] [varchar](50) NULL,
 CONSTRAINT [PK__ServiceD__DF4C9D5702192B98] PRIMARY KEY CLUSTERED 
(
	[ServiceDataFeatureId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


