CREATE TABLE [admin].[Actions] (
    [ActionId]    INT          IDENTITY (1, 1) NOT NULL,
    [ActionDescr] VARCHAR (50) NOT NULL,
    [Active]      BIT          CONSTRAINT [DF__Actions__Obsolet__579B7187] DEFAULT ((1)) NOT NULL,
    [CategoryId]  INT          NULL,
    PRIMARY KEY CLUSTERED ([ActionId] ASC)
);

