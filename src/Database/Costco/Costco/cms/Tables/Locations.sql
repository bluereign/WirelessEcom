CREATE TABLE [cms].[Locations] (
    [LocationID]   BIGINT           IDENTITY (1, 1) NOT NULL,
    [LocationGUID] UNIQUEIDENTIFIER CONSTRAINT [DF_Locations_LocationGUID] DEFAULT (newid()) NOT NULL,
    [SiteGroupID]  BIGINT           NOT NULL,
    [PageName]     VARCHAR (50)     NOT NULL,
    [LocationName] VARCHAR (50)     NOT NULL,
    CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED ([LocationID] ASC),
    CONSTRAINT [FK_Locations_SiteGroups] FOREIGN KEY ([SiteGroupID]) REFERENCES [cms].[SiteGroups] ([SiteGroupID]) NOT FOR REPLICATION
);


GO
ALTER TABLE [cms].[Locations] NOCHECK CONSTRAINT [FK_Locations_SiteGroups];

