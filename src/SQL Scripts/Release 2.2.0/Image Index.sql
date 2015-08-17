
/****** Object:  Index [IX_catalog_Image_ReferenceGuid_Ordinal]    Script Date: 08/16/2011 15:50:15 ******/
CREATE NONCLUSTERED INDEX [IX_catalog_Image_ReferenceGuid_Ordinal] ON [catalog].[Image] 
(
	[ReferenceGuid] ASC,
	[Ordinal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


