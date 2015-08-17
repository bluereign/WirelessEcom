CREATE TABLE [catalog].[SessionStockReservation] (
    [SessionId]    VARCHAR (36) NOT NULL,
    [GroupNumber]  INT          NOT NULL,
    [ProductId]    INT          NOT NULL,
    [Qty]          INT          NOT NULL,
    [ReservedTime] DATETIME     NOT NULL
);

