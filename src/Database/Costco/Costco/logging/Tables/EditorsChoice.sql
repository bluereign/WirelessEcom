CREATE TABLE [logging].[EditorsChoice] (
    [EntryId]   INT          IDENTITY (1, 1) NOT NULL,
    [StartDate] DATETIME     NULL,
    [ECOrder]   INT          NULL,
    [ProductId] INT          NULL,
    [GersSku]   NVARCHAR (9) NULL
);

