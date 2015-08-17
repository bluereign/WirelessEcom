CREATE TABLE [notification].[CustomerMarketingCampaign] (
    [CustomerMarketingCampaignId] INT      IDENTITY (1, 1) NOT NULL,
    [CustomerId]                  INT      NOT NULL,
    [MarketingCampaignId]         INT      NOT NULL,
    [SentDateTime]                DATETIME NULL,
    CONSTRAINT [PK_CustomerMarketingCampaign_1] PRIMARY KEY CLUSTERED ([CustomerMarketingCampaignId] ASC)
);

