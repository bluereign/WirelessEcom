CREATE TABLE [cms].[SiteTemplates] (
    [SiteTemplateID] BIGINT IDENTITY (1, 1) NOT NULL,
    [SiteGroupID]    BIGINT NOT NULL,
    [TemplateID]     BIGINT NOT NULL,
    [CacheTemplate]  BIT    CONSTRAINT [DF_SiteTemplates_CacheTemplate] DEFAULT ((1)) NOT NULL,
    [CacheInterval]  INT    CONSTRAINT [DF_SiteTemplates_CacheInterval] DEFAULT ((10)) NOT NULL,
    CONSTRAINT [PK_SiteTemplates] PRIMARY KEY CLUSTERED ([SiteTemplateID] ASC),
    CONSTRAINT [FK_SiteTemplates_Sites] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[Sites] ([SiteID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_SiteTemplates_Templates] FOREIGN KEY ([TemplateID]) REFERENCES [cms].[Templates] ([TemplateID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[SiteTemplates] NOCHECK CONSTRAINT [FK_SiteTemplates_Sites];


GO
ALTER TABLE [cms].[SiteTemplates] NOCHECK CONSTRAINT [FK_SiteTemplates_Templates];

