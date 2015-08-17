CREATE TABLE [admin].[OrderNote] (
    [OrderNoteId]        INT      IDENTITY (1, 1) NOT NULL,
    [OrderId]            INT      NOT NULL,
    [OrderNoteSubjectId] INT      NULL,
    [DateCreated]        DATETIME NULL,
    [CreatedById]        INT      NOT NULL,
    [NoteBody]           TEXT     NULL,
    PRIMARY KEY CLUSTERED ([OrderNoteId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Can be linked to various tables in the [salesorder] schema', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNote', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNote', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNote', @level2type = N'COLUMN', @level2name = N'OrderNoteId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Notes left on the order by customer care.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'OrderNote';

