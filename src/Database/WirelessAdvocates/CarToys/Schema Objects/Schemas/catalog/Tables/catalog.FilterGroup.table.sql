CREATE TABLE [catalog].[FilterGroup] (
    [FilterGroupId]       INT           IDENTITY (1, 1) NOT NULL,
    [ProductType]         VARCHAR (50)  NOT NULL,
    [Label]               VARCHAR (100) NOT NULL,
    [FieldName]           VARCHAR (100) NOT NULL,
    [AllowSelectMultiple] INT           NOT NULL,
    [Ordinal]             INT           NOT NULL,
    [Active]              INT           NOT NULL
);

