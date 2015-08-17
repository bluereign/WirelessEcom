CREATE TABLE [ALLOCATION].[MessageDestination] (
    [LocationId]  INT            IDENTITY (1, 1) NOT NULL,
    [Destination] NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_LocationId] PRIMARY KEY CLUSTERED ([LocationId] ASC)
);

