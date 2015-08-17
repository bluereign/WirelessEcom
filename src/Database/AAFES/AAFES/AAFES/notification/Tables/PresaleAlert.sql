CREATE TABLE [notification].[PresaleAlert] (
    [PresaleAlertId]       INT          IDENTITY (1, 1) NOT NULL,
    [Email]                VARCHAR (50) NOT NULL,
    [SignUpDateTime]       DATETIME     NOT NULL,
    [PresaleStartDateTime] DATETIME     NULL,
    [CarrierId]            INT          NOT NULL,
    [SentDateTime]         DATETIME     NULL,
    CONSTRAINT [PK_PresaleAlert] PRIMARY KEY CLUSTERED ([PresaleAlertId] ASC)
);

