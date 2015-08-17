CREATE TABLE [cms].[ReleaseTemplates] (
    [ReleaseTemplateID] BIGINT IDENTITY (1, 1) NOT NULL,
    [Enabled]           BIT    NULL,
    [ReleaseID]         BIGINT NOT NULL,
    [TemplateID]        BIGINT NOT NULL,
    [LocationID]        BIGINT NULL,
    CONSTRAINT [PK_ReleaseTemplates] PRIMARY KEY CLUSTERED ([ReleaseTemplateID] ASC),
    CONSTRAINT [FK_ReleaseTemplates_Locations] FOREIGN KEY ([LocationID]) REFERENCES [cms].[Locations] ([LocationID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ReleaseTemplates_Releases] FOREIGN KEY ([ReleaseID]) REFERENCES [cms].[Releases] ([ReleaseID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ReleaseTemplates_TemplateReleaseContent] FOREIGN KEY ([TemplateID]) REFERENCES [cms].[TemplateReleaseContent] ([TemplateReleaseContentID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ReleaseTemplates_Templates] FOREIGN KEY ([TemplateID]) REFERENCES [cms].[Templates] ([TemplateID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[ReleaseTemplates] NOCHECK CONSTRAINT [FK_ReleaseTemplates_Locations];


GO
ALTER TABLE [cms].[ReleaseTemplates] NOCHECK CONSTRAINT [FK_ReleaseTemplates_Releases];


GO
ALTER TABLE [cms].[ReleaseTemplates] NOCHECK CONSTRAINT [FK_ReleaseTemplates_TemplateReleaseContent];


GO
ALTER TABLE [cms].[ReleaseTemplates] NOCHECK CONSTRAINT [FK_ReleaseTemplates_Templates];

