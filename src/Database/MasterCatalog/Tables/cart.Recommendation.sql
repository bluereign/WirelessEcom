CREATE TABLE [cart].[Recommendation]
(
[RecommendationId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductId] [int] NOT NULL,
[hidemessage] [bit] NOT NULL CONSTRAINT [DF__Recommend__hidem__423842ED] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [cart].[Recommendation] ADD CONSTRAINT [PK__Recommen__AA15BEE4392D3049] PRIMARY KEY CLUSTERED  ([RecommendationId]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Bug', N'4147, http://tfserver:8080/tfs/web/wi.aspx?id=4147&pguid=9af0ae7b-6890-4e1a-81aa-368b430d7527', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DELETE IN PROGRESS. PER E-MAIL WITH RANDOLPH.', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', NULL, NULL
GO
EXEC sp_addextendedproperty N'Owner', N'Naomi Hall', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', NULL, NULL
GO
EXEC sp_addextendedproperty N'CreateDate', N'19-SEP-2012', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', 'COLUMN', N'RecommendationId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key', 'SCHEMA', N'cart', 'TABLE', N'Recommendation', 'COLUMN', N'RecommendationId'
GO
