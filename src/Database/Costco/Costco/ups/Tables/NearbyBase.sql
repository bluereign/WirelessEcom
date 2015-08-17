CREATE TABLE [ups].[NearbyBase] (
    [EntryId]      INT            IDENTITY (1, 1) NOT NULL,
    [BranchId]     INT            NOT NULL,
    [KioskCode]    INT            NOT NULL,
    [SearchTerm]   NVARCHAR (100) NOT NULL,
    [BaseName]     NVARCHAR (100) NOT NULL,
    [CompleteName] NVARCHAR (100) NOT NULL,
    [CreateDate]   DATE           NOT NULL,
    [Active]       BIT            NOT NULL
);

