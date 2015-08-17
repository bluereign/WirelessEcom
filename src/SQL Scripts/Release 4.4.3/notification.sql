CREATE SCHEMA notification
GO

/****** Object:  Table [notification].[UpgradeEligibility]    Script Date: 04/23/2013 16:51:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [notification].[UpgradeEligibility](
	[UpgradeEligibilityId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[SignUpDateTime] [datetime] NOT NULL,
	[EligibleMdn] [varchar](15) NOT NULL,
	[EligibilityDate] [date] NULL,
	[CarrierId] [int] NOT NULL,
	[SentDateTime] [datetime] NULL,
 CONSTRAINT [PK_UpgradeEligibility] PRIMARY KEY CLUSTERED 
(
	[UpgradeEligibilityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


