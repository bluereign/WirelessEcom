CREATE TABLE [notification].[MarketingCampaign] (
    [MarketingCampaignId] INT          IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (50) NOT NULL,
    [CampaignDateTime]    DATETIME     NULL
);

