CREATE TABLE [logging].[Activity] (
    [ActivityId]          INT            IDENTITY (1, 1) NOT NULL,
    [UserId]              INT            NULL,
    [Type]                VARCHAR (50)   NULL,
    [TypeReferenceId]     VARCHAR (50)   NULL,
    [PrimaryActivityType] VARCHAR (50)   NULL,
    [Description]         VARCHAR (1000) NULL,
    [Timestamp]           DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ActivityId] ASC) WITH (FILLFACTOR = 80)
);

