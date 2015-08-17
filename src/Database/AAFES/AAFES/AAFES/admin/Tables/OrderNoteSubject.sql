CREATE TABLE [admin].[OrderNoteSubject] (
    [OrderNoteSubjectId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]               VARCHAR (100) NULL,
    [Ordinal]            INT           NULL,
    PRIMARY KEY CLUSTERED ([OrderNoteSubjectId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNoteSubject', @level2type = N'COLUMN', @level2name = N'OrderNoteSubjectId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNoteSubject', @level2type = N'COLUMN', @level2name = N'OrderNoteSubjectId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The subject of an order note is stored here.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNoteSubject';

