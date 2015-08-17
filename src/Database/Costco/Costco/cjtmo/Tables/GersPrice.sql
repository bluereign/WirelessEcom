CREATE TABLE [cjtmo].[GersPrice] (
    [GersSku]        NVARCHAR (9)  NOT NULL,
    [PriceGroupCode] NVARCHAR (3)  NOT NULL,
    [Price]          MONEY         NOT NULL,
    [StartDate]      DATE          NOT NULL,
    [EndDate]        DATE          NOT NULL,
    [Comment]        NVARCHAR (70) NULL,
    [InsertDate]     DATETIME      CONSTRAINT [CJTMO_GersPrice_CreateDate] DEFAULT (getdate()) NOT NULL
);

