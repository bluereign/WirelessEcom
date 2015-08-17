CREATE TABLE [cms].[Sites] (
    [SiteID]         BIGINT           IDENTITY (1, 1) NOT NULL,
    [SiteGUID]       UNIQUEIDENTIFIER CONSTRAINT [DF_Sites_SiteGUID] DEFAULT (newid()) NOT NULL,
    [SiteGroupID]    BIGINT           NOT NULL,
    [EnvironmentID]  BIGINT           NOT NULL,
    [URLIdentifier]  VARCHAR (255)    NULL,
    [StaticImageURL] VARCHAR (255)    NOT NULL,
    [SiteURL]        VARCHAR (255)    NOT NULL,
    [Locked]         BIT              CONSTRAINT [DF_Sites_Locked] DEFAULT ((0)) NOT NULL,
    [DisableCache]   BIT              NOT NULL,
    CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED ([SiteID] ASC),
    CONSTRAINT [FK_Sites_SiteGroups] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[SiteGroups] ([SiteGroupID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[Sites] NOCHECK CONSTRAINT [FK_Sites_SiteGroups];

