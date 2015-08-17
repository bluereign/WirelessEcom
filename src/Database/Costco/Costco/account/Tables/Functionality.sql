CREATE TABLE [account].[Functionality] (
    [FunctionalityGuid] UNIQUEIDENTIFIER CONSTRAINT [DF_Functionality_FunctionalityGuid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [Functionality]     VARCHAR (50)     NOT NULL,
    [Description]       VARCHAR (200)    NULL,
    CONSTRAINT [PK_Functionality] PRIMARY KEY CLUSTERED ([FunctionalityGuid] ASC)
);

