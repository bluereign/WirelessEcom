
/****** Object:  Table [logging].[InvalidCart]    Script Date: 03/12/2013 11:32:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [logging].[InvalidCart](
	[InvalidCartId] [int] IDENTITY(1,1) NOT NULL,
	[InvalidCartTypeId] [int] NULL,
	[ActivationType] [varchar](50) NULL,
	[CarrierId] [int] NULL,
	[Message] [varchar](max) NULL,
	[DateTimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_InvalidCart] PRIMARY KEY CLUSTERED 
(
	[InvalidCartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [logging].[InvalidCart] ADD  CONSTRAINT [DF_InvalidCart_DateTimeCreated]  DEFAULT (getdate()) FOR [DateTimeCreated]
GO


