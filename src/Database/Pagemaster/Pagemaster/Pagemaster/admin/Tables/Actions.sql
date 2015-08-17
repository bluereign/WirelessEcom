CREATE TABLE [admin].[Actions] (
    [ActionId]    INT          IDENTITY (1, 1) NOT NULL,
    [ActionDescr] VARCHAR (50) NOT NULL,
    [CategoryId]  INT          NULL,
    [Active]      BIT          CONSTRAINT [DF_Actions_Active] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Actions] PRIMARY KEY CLUSTERED ([ActionId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [fk_CategoryId_pid] FOREIGN KEY ([CategoryId]) REFERENCES [admin].[Category] ([CategoryId])
);

