

/****** Object:  Table [notification].[CustomerMarketingCampaign]    Script Date: 03/05/2014 18:50:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [notification].[CustomerMarketingCampaign](
	[CustomerMarketingCampaignId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[MarketingCampaignId] [int] NOT NULL,
	[SentDateTime] [datetime] NULL,
 CONSTRAINT [PK_CustomerMarketingCampaign_1] PRIMARY KEY CLUSTERED 
(
	[CustomerMarketingCampaignId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


