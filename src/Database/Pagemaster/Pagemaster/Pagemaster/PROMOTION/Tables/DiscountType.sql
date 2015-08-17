CREATE TABLE [PROMOTION].[DiscountType] (
    [DiscountTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]           NVARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([DiscountTypeId] ASC)
);

