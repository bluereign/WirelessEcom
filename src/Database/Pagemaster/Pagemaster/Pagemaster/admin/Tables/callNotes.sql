CREATE TABLE [admin].[callNotes] (
    [noteId]       INT            IDENTITY (1, 1) NOT NULL,
    [adminUserId]  INT            NULL,
    [emailAddress] NVARCHAR (255) NULL,
    [message]      NVARCHAR (MAX) NULL,
    [dateCreated]  DATETIME       NULL,
    [subjectId]    INT            NULL,
    CONSTRAINT [PK__callNote__03C97EFD17CC3C7E] PRIMARY KEY CLUSTERED ([noteId] ASC) WITH (FILLFACTOR = 80)
);

