GO

/****** Object:  Table [logging].[InvalidCartType]    Script Date: 03/12/2013 11:32:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [logging].[InvalidCartType](
	[InvalidCartTypeId] [int] IDENTITY(1,1) NOT NULL,
	[InvalidMessage] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InvalidCartTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


