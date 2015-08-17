CREATE TABLE [cms].[TemplateReleaseContent] (
    [TemplateReleaseContentID] BIGINT           IDENTITY (1, 1) NOT NULL,
    [TemplateID]               BIGINT           NOT NULL,
    [ReleaseID]                BIGINT           NOT NULL,
    [ReleaseTemplateID]        BIGINT           NOT NULL,
    [ContentID]                UNIQUEIDENTIFIER NULL,
    [DisplayOrder]             INT              NULL,
    CONSTRAINT [PK_TemplateReleaseContent] PRIMARY KEY CLUSTERED ([TemplateReleaseContentID] ASC),
    CONSTRAINT [FK_TemplateReleaseContent_Content] FOREIGN KEY ([ContentID]) REFERENCES [cms].[Content] ([ContentID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[TemplateReleaseContent] NOCHECK CONSTRAINT [FK_TemplateReleaseContent_Content];

