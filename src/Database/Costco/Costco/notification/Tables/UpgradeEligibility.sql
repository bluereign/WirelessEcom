CREATE TABLE [notification].[UpgradeEligibility] (
    [UpgradeEligibilityId] INT          IDENTITY (1, 1) NOT NULL,
    [Email]                VARCHAR (50) NOT NULL,
    [SignUpDateTime]       DATETIME     NOT NULL,
    [EligibleMdn]          VARCHAR (15) NOT NULL,
    [EligibilityDate]      DATE         NULL,
    [CarrierId]            INT          NOT NULL,
    [SentDateTime]         DATETIME     NULL,
    CONSTRAINT [PK_UpgradeEligibility] PRIMARY KEY CLUSTERED ([UpgradeEligibilityId] ASC)
);

