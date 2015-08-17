CREATE TABLE [service].[EmailTemplate] (
    [Id]             INT            IDENTITY (1, 1) NOT NULL,
    [Title]          VARCHAR (255)  NOT NULL,
    [Description]    VARCHAR (255)  NULL,
    [Subject]        VARCHAR (500)  NULL,
    [Body]           TEXT           NULL,
    [DefaultTo]      VARCHAR (255)  NULL,
    [DefaultCC]      VARCHAR (255)  NULL,
    [DefaultBCC]     VARCHAR (255)  NULL,
    [Query]          VARCHAR (5000) NULL,
    [Active]         BIT            NOT NULL,
    [LastModified]   DATETIME       NULL,
    [LastModifiedBy] VARCHAR (50)   NULL,
    [Parameters]     VARCHAR (255)  NULL
);

