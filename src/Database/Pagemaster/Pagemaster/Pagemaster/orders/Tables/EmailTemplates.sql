CREATE TABLE [orders].[EmailTemplates] (
    [EmailTemplateID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [Title]           VARCHAR (255)  NULL,
    [Subject]         VARCHAR (1024) NULL,
    [Template]        VARCHAR (8000) NULL,
    CONSTRAINT [PK_EmailTemplateID] PRIMARY KEY CLUSTERED ([EmailTemplateID] ASC)
);

