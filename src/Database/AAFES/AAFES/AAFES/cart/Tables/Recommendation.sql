CREATE TABLE [cart].[Recommendation] (
    [RecommendationId] INT           IDENTITY (1, 1) NOT NULL,
    [Description]      VARCHAR (500) NULL,
    [ProductId]        INT           NOT NULL,
    [hidemessage]      BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Recommen__AA15BEE4392D3049] PRIMARY KEY CLUSTERED ([RecommendationId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation', @level2type = N'COLUMN', @level2name = N'RecommendationId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation', @level2type = N'COLUMN', @level2name = N'RecommendationId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'Naomi Hall', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DELETE IN PROGRESS. PER E-MAIL WITH RANDOLPH.', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'4147, http://tfserver:8080/tfs/web/wi.aspx?id=4147&pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527', @level0type = N'SCHEMA', @level0name = N'cart', @level1type = N'TABLE', @level1name = N'Recommendation';

