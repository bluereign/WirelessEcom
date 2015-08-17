CREATE TABLE [cart].[Recommendation] (
    [RecommendationId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (500) NULL,
    [ProductId]        INT           NOT NULL,
    [hidemessage]      BIT           DEFAULT ((0)) NOT NULL
);

