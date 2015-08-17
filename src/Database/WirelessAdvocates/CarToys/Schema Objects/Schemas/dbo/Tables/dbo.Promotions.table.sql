CREATE TABLE [dbo].[Promotions] (
    [PromotionID]     INT           IDENTITY (1, 1) NOT NULL,
    [PromotionName]   VARCHAR (50)  NOT NULL,
    [PromotionDesc]   VARCHAR (500) NULL,
    [EmailTracker]    VARCHAR (50)  NULL,
    [EmailTrackerURL] VARCHAR (50)  NULL,
    [DateStart]       DATETIME      NOT NULL,
    [DateEnd]         DATETIME      NOT NULL,
    [CreatedBy]       VARCHAR (50)  NULL,
    [CreateDate]      DATETIME      NOT NULL,
    [Active]          BIT           NOT NULL
);

