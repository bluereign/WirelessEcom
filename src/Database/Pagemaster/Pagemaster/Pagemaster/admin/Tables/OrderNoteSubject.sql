CREATE TABLE [admin].[OrderNoteSubject] (
    [OrderNoteSubjectId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (100) NULL,
    [Ordinal]            INT           NULL,
    PRIMARY KEY CLUSTERED ([OrderNoteSubjectId] ASC)
);

