CREATE TABLE [admin].[callNoteSubjects] (
    [subjectId] INT            IDENTITY (1, 1) NOT NULL,
    [subject]   NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([subjectId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNoteSubjects', @level2type = N'COLUMN', @level2name = N'subjectId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNoteSubjects', @level2type = N'COLUMN', @level2name = N'subjectId';

