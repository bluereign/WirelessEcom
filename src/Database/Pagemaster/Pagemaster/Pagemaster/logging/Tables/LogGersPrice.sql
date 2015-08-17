CREATE TABLE [logging].[LogGersPrice] (
    [GersSku]        NVARCHAR (9)  NOT NULL,
    [PriceGroupCode] NVARCHAR (3)  NOT NULL,
    [Price]          MONEY         NOT NULL,
    [StartDate]      DATE          NOT NULL,
    [EndDate]        DATE          NOT NULL,
    [Comment]        NVARCHAR (70) NULL,
    [Changes]        NVARCHAR (1)  NULL,
    [ChangeDate]     DATETIME      NULL
);

