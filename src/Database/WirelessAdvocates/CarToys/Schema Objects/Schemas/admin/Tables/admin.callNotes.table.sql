CREATE TABLE [admin].[callNotes] (
    [noteId]       INT            IDENTITY (1, 1) NOT NULL,
    [adminUserId]  INT            NULL,
    [emailAddress] NVARCHAR (255) NULL,
    [message]      NVARCHAR (MAX) NULL,
    [dateCreated]  DATETIME       NULL,
    [subjectId]    INT            NULL
);

