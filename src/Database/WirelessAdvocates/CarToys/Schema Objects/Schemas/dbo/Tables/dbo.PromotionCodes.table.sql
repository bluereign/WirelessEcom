CREATE TABLE [dbo].[PromotionCodes] (
    [PromotionId]    INT             IDENTITY (1, 1) NOT NULL,
    [PromotionCode]  VARCHAR (50)    NOT NULL,
    [ValidStartDate] DATETIME        NULL,
    [ValidEndDate]   DATETIME        NULL,
    [DateCreated]    DATETIME        NOT NULL,
    [DiscountValue]  DECIMAL (18, 2) NULL,
    [CreatedBy]      INT             NULL,
    [LastUpdated]    DATETIME        NULL,
    [UpdatedBy]      INT             NULL,
    [MinPurchase]    MONEY           NULL,
    [BundleId]       INT             NULL,
    [PromotionType]  NVARCHAR (1)    NULL
);

