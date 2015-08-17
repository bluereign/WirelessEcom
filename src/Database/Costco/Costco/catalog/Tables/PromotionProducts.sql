CREATE TABLE [catalog].[PromotionProducts] (
    [PromotionItemId] INT          IDENTITY (1, 1) NOT NULL,
    [PromotionId]     INT          NULL,
    [ConditionId]     INT          NULL,
    [GersSku]         NVARCHAR (9) NOT NULL,
    PRIMARY KEY CLUSTERED ([PromotionItemId] ASC),
    CONSTRAINT [fk_Products] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]),
    CONSTRAINT [fk_PromotionCodes] FOREIGN KEY ([PromotionId]) REFERENCES [catalog].[Promotion] ([PromotionId]),
    CONSTRAINT [fk_PromotionCondition] FOREIGN KEY ([ConditionId]) REFERENCES [PROMOTION].[Condition] ([PromotionConditionId])
);

