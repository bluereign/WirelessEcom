


/****** Object:  Table [notification].[Customer]    Script Date: 03/05/2014 18:49:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [notification].[Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[SignUpDateTime] [datetime] NOT NULL,
	[OptOutDateTime] [datetime] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [notification].[Customer] ADD  CONSTRAINT [DF__CustomerS__Activ__524EE0EF]  DEFAULT ((1)) FOR [Active]
GO


