IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[salesorder].[FK__Order__DiscountC__337C4859]') AND parent_object_id = OBJECT_ID(N'[salesorder].[Order]'))
ALTER TABLE [salesorder].[Order] DROP CONSTRAINT [FK__Order__DiscountC__337C4859]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Coupon_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Coupon] DROP CONSTRAINT [DF_Coupon_DateCreated]
END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Coupon]') AND type in (N'U'))
DROP TABLE [dbo].[Coupon]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[catalog].[FK__Coupon__CreatedB__3A2945E8]') AND parent_object_id = OBJECT_ID(N'[catalog].[Coupon]'))
ALTER TABLE [catalog].[Coupon] DROP CONSTRAINT [FK__Coupon__CreatedB__3A2945E8]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Coupon_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [catalog].[Coupon] DROP CONSTRAINT [DF_Coupon_DateCreated]
END
GO

/****** Object:  Table [catalog].[Coupon]    Script Date: 06/07/2013 15:14:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[Coupon]') AND type in (N'U'))
DROP TABLE [catalog].[Coupon]
GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [catalog].[Coupon](
	[CouponId] [int] IDENTITY(1,1) NOT NULL,
	[CouponCode] [varchar](50) NOT NULL,
	[ValidStartDate] [datetime] NOT NULL,
	[ValidEndDate] [datetime] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DiscountValue] [money] NOT NULL,
	[CreatedBy] [int] NULL,
	[LastUpdated] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[MinPurchase] [money] NULL,
 CONSTRAINT [PK_Coupon] PRIMARY KEY CLUSTERED 
(
	[CouponId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [catalog].[Coupon] ADD  CONSTRAINT [DF_Coupon_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]

UPDATE [salesorder].[Order] SET DiscountCode = NULL

ALTER TABLE [salesorder].[order] ALTER COLUMN [DiscountCode] INTEGER NULL

ALTER TABLE [salesorder].[order] ADD FOREIGN KEY (DiscountCode) REFERENCES [catalog].[Coupon] (CouponId)

ALTER TABLE [catalog].[Coupon] ADD FOREIGN KEY (CreatedBy) REFERENCES [dbo].[Users] (User_Id)

INSERT INTO catalog.coupon (CouponCode, ValidStartDate, ValidEndDate, DiscountValue, CreatedBy)
VALUES ('SUPERPHONE',GETDATE()-50,GETDATE()+40,'5.00','26007425')
, ('STELLARSAVE',GETDATE()+50,GETDATE()+100,'15.00','26007425')
, ('STELLARSAVE',GETDATE()-50,GETDATE()+10,'155.00','26007425')

SELECT * FROM catalog.coupon

