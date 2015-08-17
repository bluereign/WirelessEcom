CREATE TABLE [cms].[DataGroups] (
    [DataGroupID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [TemplateID]  BIGINT         NOT NULL,
    [SelectSQL]   VARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_DataGroups] PRIMARY KEY CLUSTERED ([DataGroupID] ASC),
    CONSTRAINT [FK_DataGroups_Templates] FOREIGN KEY ([TemplateID]) REFERENCES [cms].[Templates] ([TemplateID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[DataGroups] NOCHECK CONSTRAINT [FK_DataGroups_Templates];

