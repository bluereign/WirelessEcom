CREATE TABLE [logging].[Cart] (
    [ActivityId]    INT            IDENTITY (1, 1) NOT NULL,
    [CFIDCFTOKEN]   VARCHAR (255)  NULL,
    [UserId]        INT            CONSTRAINT [DF__Cart__UserId__18639B60] DEFAULT ((0)) NULL,
    [Path]          VARCHAR (255)  NULL,
    [ProductIDList] VARCHAR (1000) NULL,
    [ItemCount]     INT            NULL,
    [Timestamp]     DATETIME       CONSTRAINT [DF__Cart__Timestamp__176F7727] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK__Cart__45F4A79115872EB5] PRIMARY KEY CLUSTERED ([ActivityId] ASC) WITH (FILLFACTOR = 80)
);

