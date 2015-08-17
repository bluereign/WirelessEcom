CREATE TABLE [PROMOTION].[RemainingQuantity] (
    [PromotionDurationId] INT IDENTITY (1, 1) NOT NULL,
    [PromotionId]         INT NULL,
    [RemainingQuantity]   INT NULL,
    PRIMARY KEY CLUSTERED ([PromotionDurationId] ASC),
    CONSTRAINT [fk_Promotions] FOREIGN KEY ([PromotionId]) REFERENCES [catalog].[Promotion] ([PromotionId])
);

