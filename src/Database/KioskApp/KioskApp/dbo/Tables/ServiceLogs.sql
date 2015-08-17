CREATE TABLE [dbo].[ServiceLogs] (
    [ServiceLogId]   INT            IDENTITY (1, 1) NOT NULL,
    [LoggedDateTime] DATETIME       NOT NULL,
    [ReferenceId]    NVARCHAR (50)  NULL,
    [ApiName]        NVARCHAR (50)  NULL,
    [LogType]        NVARCHAR (50)  NULL,
    [LogDirection]   NVARCHAR (8)   NULL,
    [Data]           NVARCHAR (MAX) NULL,
    [ClientId]       NVARCHAR (50)  NULL,
    CONSTRAINT [PK_dbo.ServiceLogs] PRIMARY KEY CLUSTERED ([ServiceLogId] ASC)
);



