CREATE TABLE [admin].[OrderNoteSubject] (
    [OrderNoteSubjectId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (100) NULL,
    [Ordinal]            INT           NULL,
    PRIMARY KEY CLUSTERED ([OrderNoteSubjectId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

