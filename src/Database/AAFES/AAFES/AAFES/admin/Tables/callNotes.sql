CREATE TABLE [admin].[callNotes] (
    [noteId]       INT            IDENTITY (1, 1) NOT NULL,
    [adminUserId]  INT            NULL,
    [emailAddress] NVARCHAR (255) NULL,
    [message]      NVARCHAR (MAX) NULL,
    [dateCreated]  DATETIME       NULL,
    [subjectId]    INT            NULL,
    CONSTRAINT [PK__callNote__03C97EFD17CC3C7E] PRIMARY KEY CLUSTERED ([noteId] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links to [dbo].[users] table', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNotes', @level2type = N'COLUMN', @level2name = N'adminUserId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNotes', @level2type = N'COLUMN', @level2name = N'adminUserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNotes', @level2type = N'COLUMN', @level2name = N'noteId';


GO
EXECUTE sp_addextendedproperty @name = N'CreateDate', @value = N'19-SEP-2012', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNotes', @level2type = N'COLUMN', @level2name = N'noteId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Notes entered in by customer care after taking a call.', @level0type = N'SCHEMA', @level0name = N'admin', @level1type = N'TABLE', @level1name = N'callNotes';

