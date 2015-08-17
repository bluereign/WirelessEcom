CREATE TABLE [catalog].[PromotionProducts]
(
[PromotionItemId] [int] NOT NULL IDENTITY(1, 1),
[GersSku] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [catalog].[PromotionProducts] ADD CONSTRAINT [PK__Promotio__2B1778CC7F928FFF] PRIMARY KEY CLUSTERED  ([PromotionItemId]) ON [PRIMARY]
GO
ALTER TABLE [catalog].[PromotionProducts] ADD CONSTRAINT [fk_Products] FOREIGN KEY ([GersSku]) REFERENCES [catalog].[GersItm] ([GersSku])
GO
