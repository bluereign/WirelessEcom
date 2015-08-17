ALTER TABLE salesorder.[Order] ADD PaymentGatewayId int 

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[salesorder].[fk_PaymentGatewayType]') AND parent_object_id = OBJECT_ID(N'[salesorder].[Order]'))
ALTER TABLE [salesorder].[Order] DROP CONSTRAINT [fk_PaymentGatewayType]
GO



/****** Object:  Table [service].[PaymentGatewayType]    Script Date: 06/12/2013 14:43:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[service].[PaymentGatewayType]') AND type in (N'U'))
DROP TABLE [service].[PaymentGatewayType]
GO





/****** Object:  Table [service].[PaymentGatewayType]    Script Date: 06/12/2013 14:43:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [service].[PaymentGatewayType](
	[PaymentGatewayId] [int] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentGatewayId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [salesorder].[Order]  WITH CHECK ADD  CONSTRAINT [fk_PaymentGatewayType] FOREIGN KEY([PaymentGatewayId])
REFERENCES [service].[PaymentGatewayType] ([PaymentGatewayId])
GO

ALTER TABLE [salesorder].[Order] CHECK CONSTRAINT [fk_PaymentGatewayType]
GO


