SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [service].[OrderDetailLog](
      [OrderDetailLogId] [int] IDENTITY(1,1) NOT NULL,
      [LoggedDateTime] [datetime] NOT NULL,
      [OrderDetailId] [int] NULL,
      [Source] [varchar](150) NULL,
      [Type] [varchar](50) NULL,
      [Log] [XML] NULL
      ,CONSTRAINT pk_OrderDetailLogId PRIMARY KEY (OrderDetailLogId)
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [service].[OrderDetailLog] ADD  CONSTRAINT [FK_OrderDetailID_LogId]  FOREIGN KEY (OrderDetailId) REFERENCES [salesorder].[OrderDetail] (OrderDetailId)

ALTER TABLE [service].[OrderDetailLog] ADD  CONSTRAINT [DF_LoggedDateTime_Default]  DEFAULT (getdate()) FOR [LoggedDateTime]
GO


/*

If we need to roll back, please execute the following:

DROP TABLE [service].[OrderDetailLog]

*/
