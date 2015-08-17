CREATE TABLE [dbo].[Exactor] (
    [Commit Date]    DATETIME        NULL,
    [Sale Date]      DATETIME        NULL,
    [Invoice #]      VARCHAR (50)    NULL,
    [Customer Name]  VARCHAR (100)   NULL,
    [From State]     VARCHAR (50)    NULL,
    [To State]       VARCHAR (50)    NULL,
    [Tax Class]      VARCHAR (50)    NULL,
    [Currency]       DECIMAL (10, 2) NULL,
    [Gross Amount]   DECIMAL (10, 2) NULL,
    [Total Tax]      DECIMAL (10, 2) NULL,
    [Total Amount]   DECIMAL (10, 2) NULL,
    [Transaction ID] VARCHAR (100)   NULL
);

