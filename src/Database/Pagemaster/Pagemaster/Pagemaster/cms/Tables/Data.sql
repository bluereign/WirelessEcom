CREATE TABLE [cms].[Data] (
    [DataID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [DataGroupID]   BIGINT         NOT NULL,
    [EnvironmentID] BIGINT         NOT NULL,
    [SiteGroupID]   BIGINT         NOT NULL,
    [Connection]    VARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_Data] PRIMARY KEY CLUSTERED ([DataID] ASC)
);

