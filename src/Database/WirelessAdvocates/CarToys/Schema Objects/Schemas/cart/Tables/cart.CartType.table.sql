CREATE TABLE [cart].[CartType] (
    [CartTypeId]       INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (100) NULL,
    [ParentCartTypeId] INT           NULL,
    PRIMARY KEY CLUSTERED ([CartTypeId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

