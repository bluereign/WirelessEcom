CREATE TABLE [catalog].[FilterOption] (
    [FilterOptionId] INT            IDENTITY (1, 1) NOT NULL,
    [FilterGroupId]  INT            NOT NULL,
    [Label]          VARCHAR (100)  NOT NULL,
    [Tag]            VARCHAR (100)  NULL,
    [DynamicTag]     VARCHAR (8000) NULL,
    [Ordinal]        INT            NOT NULL,
    [Active]         INT            NOT NULL
);

