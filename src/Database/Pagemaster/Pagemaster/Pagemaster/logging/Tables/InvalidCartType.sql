CREATE TABLE [logging].[InvalidCartType] (
    [InvalidCartTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [InvalidMessage]    NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([InvalidCartTypeId] ASC)
);

