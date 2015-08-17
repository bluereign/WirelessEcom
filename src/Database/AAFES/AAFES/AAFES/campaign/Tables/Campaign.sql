CREATE TABLE [campaign].[Campaign] (
    [CampaignId]    INT             IDENTITY (1, 1) NOT NULL,
    [CompanyName]   VARCHAR (255)   NOT NULL,
    [StartDateTime] DATETIME        NOT NULL,
    [EndDateTime]   DATETIME        NOT NULL,
    [SmsMessage]    VARCHAR (165)   NULL,
    [Disclaimer]    VARCHAR (MAX)   NULL,
    [Subdomain]     VARCHAR (255)   NOT NULL,
    [LogoImage]     VARBINARY (MAX) NOT NULL,
    [BgImage]       VARBINARY (MAX) NULL,
    [AdImage]       VARBINARY (MAX) NULL,
    [Version]       INT             CONSTRAINT [DF_Campaign_Version] DEFAULT ((0)) NOT NULL,
    [IsActive]      BIT             CONSTRAINT [DF_Campaign_IsActive] DEFAULT ((1)) NOT NULL,
    [HeaderImage]   VARBINARY (MAX) NULL,
    [AdUrl]         VARCHAR (255)   NULL,
    CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED ([CampaignId] ASC)
);

