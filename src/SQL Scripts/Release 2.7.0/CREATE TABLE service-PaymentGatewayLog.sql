/****** Object:  Table [service].[PaymentGatewayLog]    Script Date: 02/02/2012 15:01:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [service].[PaymentGatewayLog](
	[PaymentGatewayLogId] [int] IDENTITY(1,1) NOT NULL,
	[LoggedDateTime] [datetime] NOT NULL,
	[OrderId] [int] NULL,
	[Type] [varchar](50) NULL,
	[RequestType] [varchar](50) NULL,
	[Data] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [service].[PaymentGatewayLog] ADD  CONSTRAINT [DF_PaymentGatewayLog_LoggedDateTime]  DEFAULT (getdate()) FOR [LoggedDateTime]
GO


