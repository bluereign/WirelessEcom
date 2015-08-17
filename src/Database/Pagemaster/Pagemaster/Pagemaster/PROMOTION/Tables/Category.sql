CREATE TABLE [PROMOTION].[Category] (
    [PromotionCategoryId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([PromotionCategoryId] ASC)
);

