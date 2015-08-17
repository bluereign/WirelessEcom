CREATE TABLE [cms].[Data] (
    [DataID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [DataGroupID]   BIGINT         NOT NULL,
    [EnvironmentID] BIGINT         NOT NULL,
    [SiteGroupID]   BIGINT         NOT NULL,
    [Connection]    VARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_Data] PRIMARY KEY CLUSTERED ([DataID] ASC),
    CONSTRAINT [FK_Data_DataGroups] FOREIGN KEY ([DataGroupID]) REFERENCES [cms].[DataGroups] ([DataGroupID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Data_Environments] FOREIGN KEY ([EnvironmentID]) REFERENCES [cms].[Environments] ([EnvironmentID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Data_SiteGroups] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[SiteGroups] ([SiteGroupID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[Data] NOCHECK CONSTRAINT [FK_Data_DataGroups];


GO
ALTER TABLE [cms].[Data] NOCHECK CONSTRAINT [FK_Data_Environments];


GO
ALTER TABLE [cms].[Data] NOCHECK CONSTRAINT [FK_Data_SiteGroups];

