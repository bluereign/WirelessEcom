CREATE TABLE [admin].[OrderNote] (
    [OrderNoteId]        INT      IDENTITY (1, 1) NOT NULL,
    [OrderId]            INT      NOT NULL,
    [OrderNoteSubjectId] INT      NULL,
    [DateCreated]        DATETIME NULL,
    [CreatedById]        INT      NOT NULL,
    [NoteBody]           TEXT     NULL,
    PRIMARY KEY CLUSTERED ([OrderNoteId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

