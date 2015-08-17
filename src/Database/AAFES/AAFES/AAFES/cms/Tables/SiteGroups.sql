CREATE TABLE [cms].[SiteGroups] (
    [SiteGroupID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (50) NOT NULL,
    [Locked]      BIT          NOT NULL,
    CONSTRAINT [PK_SiteGroups] PRIMARY KEY CLUSTERED ([SiteGroupID] ASC)
);

