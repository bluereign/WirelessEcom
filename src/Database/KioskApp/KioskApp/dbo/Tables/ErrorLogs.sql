CREATE TABLE [dbo].[ErrorLogs] (
    [ErrorLogId]     INT            IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime] DATETIME       NOT NULL,
    [ErrorCode]      NVARCHAR (50)  NULL,
    [ErrorMessage]   NVARCHAR (MAX) NULL,
    [ServiceLogId]   INT            NULL,
    CONSTRAINT [PK_dbo.ErrorLogs] PRIMARY KEY CLUSTERED ([ErrorLogId] ASC),
    CONSTRAINT [FK_dbo.ErrorLogs_dbo.ServiceLogs_ServiceLogId] FOREIGN KEY ([ServiceLogId]) REFERENCES [dbo].[ServiceLogs] ([ServiceLogId])
);




GO
CREATE NONCLUSTERED INDEX [IX_ServiceLogId]
    ON [dbo].[ErrorLogs]([ServiceLogId] ASC);

