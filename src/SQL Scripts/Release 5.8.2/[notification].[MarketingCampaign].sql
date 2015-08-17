
/****** Object:  Table [notification].[MarketingCampaign]    Script Date: 03/05/2014 18:50:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [notification].[MarketingCampaign](
	[MarketingCampaignId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CampaignDateTime] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


