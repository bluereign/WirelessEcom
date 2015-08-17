USE [CARTOYS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [gers].[KioskStaff](
	[EMP_INIT] [varchar](8) NULL,
	[EMP_CD] [varchar](10) NULL,
	[FNAME] [varchar](15) NULL,
	[LNAME] [varchar](20) NULL,
	[TITLE] [varchar](5) NULL,
	[HIREDATE] [datetime] NULL,
	[STATUS] [varchar](1) NULL,
	[HOME_STORE_CD] [varchar](2) NULL,
	[STORE_CD] [varchar](2) NULL,
	[REGION] [varchar](3) NULL,
	[DISTRICT] [varchar](3) NULL,
	[STORE_NAME] [varchar](40) NULL,
	[KioskNumber] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


