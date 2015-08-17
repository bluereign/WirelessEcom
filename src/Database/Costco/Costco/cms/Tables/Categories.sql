CREATE TABLE [cms].[Categories] (
    [CategoryID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [Name]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);

