CREATE TABLE [campaign].[CssProperty] (
    [CssPropertyId] INT           IDENTITY (1, 1) NOT NULL,
    [CampaignId]    INT           NOT NULL,
    [FormField]     VARCHAR (50)  NOT NULL,
    [Value]         VARCHAR (255) NOT NULL
);

