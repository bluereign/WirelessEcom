CREATE TABLE [catalog].[Promotion] (
    [PromotionId]        INT            IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (255)  NOT NULL,
    [Discount]           DECIMAL (5, 2) NULL,
    [ShippingMethodId]   INT            NULL,
    [MaxQuantity]        INT            NULL,
    [MaxQuantityPerUser] INT            CONSTRAINT [df_MaxQuantityPerUser] DEFAULT ((1)) NULL,
    [StartDate]          DATETIME       NULL,
    [EndDate]            DATETIME       NULL,
    [DiscountTypeId]     INT            NULL,
    [CreatedDate]        DATETIME       NOT NULL,
    [DeletedDate]        DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([PromotionId] ASC),
    CONSTRAINT [fk_PromotionDiscountType] FOREIGN KEY ([DiscountTypeId]) REFERENCES [PROMOTION].[DiscountType] ([DiscountTypeId]),
    CONSTRAINT [fk_ShippingMethod] FOREIGN KEY ([ShippingMethodId]) REFERENCES [salesorder].[ShipMethod] ([ShipMethodId])
);

