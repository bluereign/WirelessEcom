

/****** Object:  Table [service].[IncomingGersPriceGroup]    Script Date: 06/07/2013 15:08:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[service].[IncomingGersPriceGroup]') AND type in (N'U'))
DROP TABLE [service].[IncomingGersPriceGroup]
GO



/****** Object:  Table [service].[IncomingGersPriceGroup]    Script Date: 06/07/2013 15:08:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [service].[IncomingGersPriceGroup](
	[PriceGroupCode] [nvarchar](3) NOT NULL,
	[PriceGroupDescription] [nvarchar](40) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PriceGroupCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


