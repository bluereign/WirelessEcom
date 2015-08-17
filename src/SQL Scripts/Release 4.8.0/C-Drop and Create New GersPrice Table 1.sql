

/****** Object:  Table [service].[IncomingGersPrice]    Script Date: 06/07/2013 15:08:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[service].[IncomingGersPrice]') AND type in (N'U'))
DROP TABLE [service].[IncomingGersPrice]
GO



/****** Object:  Table [service].[IncomingGersPrice]    Script Date: 06/07/2013 15:08:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [service].[IncomingGersPrice](
	[GersSku] [nvarchar](9) NOT NULL,
	[PriceGroupCode] [nvarchar](3) NOT NULL,
	[Price] [money] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Comment] [nvarchar](70) NULL,
 CONSTRAINT [PK_IncomingGersPrice] PRIMARY KEY CLUSTERED 
(
	[GersSku] ASC,
	[PriceGroupCode] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


