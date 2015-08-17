CREATE TABLE [catalog].[FilterOptionMessage] (
    [FilterOptionMessageId] INT            IDENTITY (1, 1) NOT NULL,
    [FilterOptionId]        NCHAR (10)     NULL,
    [Message]               VARCHAR (1000) NULL,
    [StartDateTime]         DATETIME       NULL,
    [EndDateTime]           DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([FilterOptionMessageId] ASC),
    CONSTRAINT [FK_FilterOptionMessage_FilterOption] FOREIGN KEY ([FilterOptionMessageId]) REFERENCES [catalog].[FilterOption] ([FilterOptionId])
);

