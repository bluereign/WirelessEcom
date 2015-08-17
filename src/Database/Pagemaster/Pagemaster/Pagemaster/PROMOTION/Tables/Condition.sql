CREATE TABLE [PROMOTION].[Condition] (
    [PromotionConditionId]      INT   IDENTITY (1, 1) NOT NULL,
    [PromotionID]               INT   NOT NULL,
    [OrderTotal]                MONEY NULL,
    [OrderTotalOptional]        BIT   NULL,
    [OrderQuantity]             INT   NULL,
    [OrderQuantityOptional]     BIT   NULL,
    [OrderSKUsOptional]         BIT   NULL,
    [AccessoryTotal]            MONEY NULL,
    [AccessoryTotalOptional]    BIT   NULL,
    [AccessoryQuantity]         INT   NULL,
    [AccessoryQuantityOptional] BIT   NULL,
    PRIMARY KEY CLUSTERED ([PromotionConditionId] ASC),
    CONSTRAINT [fk_PromotionCode] FOREIGN KEY ([PromotionID]) REFERENCES [catalog].[Promotion] ([PromotionId])
);

