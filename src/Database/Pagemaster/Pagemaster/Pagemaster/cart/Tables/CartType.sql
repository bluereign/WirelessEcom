CREATE TABLE [cart].[CartType] (
    [CartTypeId]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (100) NULL,
    [ParentCartTypeId] INT           NULL,
    PRIMARY KEY CLUSTERED ([CartTypeId] ASC) WITH (FILLFACTOR = 80)
);

