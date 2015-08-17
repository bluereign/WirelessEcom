CREATE TABLE [admin].[ActionCaptures] (
    [CaptureId]    INT            IDENTITY (1, 1) NOT NULL,
    [CaptureDate]  DATETIME       DEFAULT (getdate()) NOT NULL,
    [AdminUserId]  INT            NOT NULL,
    [ActionId]     INT            NULL,
    [OrderId]      INT            NULL,
    [EmailAddress] NVARCHAR (255) NULL,
    [Message]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([CaptureId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [fk_Action_pid] FOREIGN KEY ([ActionId]) REFERENCES [admin].[Actions] ([ActionId])
);

