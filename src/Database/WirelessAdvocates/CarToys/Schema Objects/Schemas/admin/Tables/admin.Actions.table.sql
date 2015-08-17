CREATE TABLE [admin].[Actions] (
    [ActionId]    INT          IDENTITY (1, 1) NOT NULL,
    [ActionDescr] VARCHAR (50) NOT NULL,
    [Active]      BIT          NOT NULL,
    [CategoryId]  INT          NULL,
    PRIMARY KEY CLUSTERED ([ActionId] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF)
);

