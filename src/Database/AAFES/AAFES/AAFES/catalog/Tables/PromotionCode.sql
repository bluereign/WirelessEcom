CREATE TABLE [catalog].[PromotionCode] (
    [PromotionCodeId] INT           IDENTITY (1, 1) NOT NULL,
    [Code]            NVARCHAR (20) NOT NULL,
    [PromotionId]     INT           NULL,
    PRIMARY KEY CLUSTERED ([PromotionCodeId] ASC),
    CONSTRAINT [fk_CodePromotion] FOREIGN KEY ([PromotionId]) REFERENCES [catalog].[Promotion] ([PromotionId]),
    CONSTRAINT [uc_Code] UNIQUE NONCLUSTERED ([Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_PromotionCode]
    ON [catalog].[PromotionCode]([Code] ASC);

