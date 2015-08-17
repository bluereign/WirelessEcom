CREATE TABLE [admin].[callNoteSubjects] (
    [subjectId] INT            IDENTITY (1, 1) NOT NULL,
    [subject]   NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([subjectId] ASC)
);

