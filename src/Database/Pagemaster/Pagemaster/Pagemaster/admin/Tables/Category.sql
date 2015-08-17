CREATE TABLE [admin].[Category] (
    [CategoryId] INT          IDENTITY (1, 1) NOT NULL,
    [Category]   VARCHAR (50) NOT NULL,
    [Active]     BIT          DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([CategoryId] ASC) WITH (FILLFACTOR = 80)
);

