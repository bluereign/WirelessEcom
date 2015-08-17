CREATE TABLE [service].[AsyncListener] (
    [AsyncListenerGUID] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [Carrier]           VARCHAR (50)     NULL,
    [Content]           VARCHAR (MAX)    NULL,
    [CreatedDate]       DATETIME         NULL
);

