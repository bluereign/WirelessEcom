CREATE TABLE [cart].[Recommendation] (
    [RecommendationId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (500) NULL,
    [ProductId]        INT           NOT NULL,
    [hidemessage]      BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Recommen__AA15BEE4392D3049] PRIMARY KEY CLUSTERED ([RecommendationId] ASC) WITH (FILLFACTOR = 80)
);

