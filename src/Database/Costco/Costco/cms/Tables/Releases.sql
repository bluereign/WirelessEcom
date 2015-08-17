CREATE TABLE [cms].[Releases] (
    [ReleaseID]     BIGINT       IDENTITY (1, 1) NOT NULL,
    [Active]        BIT          NOT NULL,
    [SiteGroupID]   BIGINT       NOT NULL,
    [EnvironmentID] BIGINT       NOT NULL,
    [Name]          VARCHAR (50) NOT NULL,
    [ReleaseDate]   DATETIME     NULL,
    [CreatedBy]     VARCHAR (50) NULL,
    [CreatedOn]     DATETIME     CONSTRAINT [DF_Releases_CreatedOn_1] DEFAULT (getdate()) NULL,
    [ModifiedBy]    VARCHAR (50) NULL,
    [ModifiedOn]    DATETIME     NULL,
    CONSTRAINT [PK_Releases] PRIMARY KEY CLUSTERED ([ReleaseID] ASC),
    CONSTRAINT [FK_Releases_Environments] FOREIGN KEY ([EnvironmentID]) REFERENCES [cms].[Environments] ([EnvironmentID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Releases_SiteGroups] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[SiteGroups] ([SiteGroupID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_Releases_Sites] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[Sites] ([SiteID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[Releases] NOCHECK CONSTRAINT [FK_Releases_Environments];


GO
ALTER TABLE [cms].[Releases] NOCHECK CONSTRAINT [FK_Releases_SiteGroups];


GO
ALTER TABLE [cms].[Releases] NOCHECK CONSTRAINT [FK_Releases_Sites];

