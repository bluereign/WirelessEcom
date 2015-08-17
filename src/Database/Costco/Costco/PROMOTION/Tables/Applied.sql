CREATE TABLE [PROMOTION].[Applied] (
    [PromotionAppliedId] INT          IDENTITY (1, 1) NOT NULL,
    [PromotionId]        INT          NOT NULL,
    [UserId]             INT          NOT NULL,
    [OrderId]            INT          NOT NULL,
    [OrderDetailId]      INT          NULL,
    [PromotionCodeId]    INT          NOT NULL,
    [Value]              VARCHAR (10) NOT NULL,
    [ApplyDate]          DATETIME     NOT NULL,
    PRIMARY KEY CLUSTERED ([PromotionAppliedId] ASC),
    CONSTRAINT [fk_AppliedToOrderDetail] FOREIGN KEY ([OrderDetailId]) REFERENCES [salesorder].[OrderDetail] ([OrderDetailId]),
    CONSTRAINT [fk_AppliedToPromotionCode] FOREIGN KEY ([PromotionCodeId]) REFERENCES [catalog].[PromotionCode] ([PromotionCodeId]),
    CONSTRAINT [fk_Orders] FOREIGN KEY ([OrderId]) REFERENCES [salesorder].[Order] ([OrderId]),
    CONSTRAINT [fk_PromotionCodes] FOREIGN KEY ([PromotionId]) REFERENCES [catalog].[Promotion] ([PromotionId]),
    CONSTRAINT [fk_Users] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([User_ID])
);

