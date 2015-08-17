CREATE TABLE [cms].[Tags] (
    [TagID]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [TemplateID]  BIGINT        NOT NULL,
    [TagKey]      VARCHAR (50)  NOT NULL,
    [Name]        VARCHAR (50)  NULL,
    [Description] VARCHAR (255) NULL,
    [TagType]     VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED ([TagID] ASC)
);

