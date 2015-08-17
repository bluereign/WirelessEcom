CREATE TABLE [service].[PromotionLog] (
    [PromotionLogId] INT           IDENTITY (1, 1) NOT NULL,
    [Code]           NVARCHAR (20) NOT NULL,
    [Passed]         BIT           NOT NULL,
    [UserId]         INT           NOT NULL,
    [PromotionId]    INT           NULL,
    [Msg]            VARCHAR (255) NOT NULL,
    [Discount]       MONEY         NULL,
    [DiscountFrom]   NVARCHAR (20) NULL,
    [GersSku]        NVARCHAR (9)  NULL,
    [CreatedDate]    DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([PromotionLogId] ASC),
    CONSTRAINT [fk_PromoLogMatched] FOREIGN KEY ([PromotionId]) REFERENCES [catalog].[Promotion] ([PromotionId]),
    CONSTRAINT [fk_PromoLogProducts] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku]),
    CONSTRAINT [fk_PromoLogUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([User_ID])
);

