CREATE TABLE [cms].[Types] (
    [TypeID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [Name]   VARCHAR (50) NULL,
    CONSTRAINT [PK_Types] PRIMARY KEY CLUSTERED ([TypeID] ASC)
);

