CREATE TABLE [salesorder].[OrderToRebates] (
    [OrderToRebateGuid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [OrderId]           INT              NOT NULL,
    [RebateGuid]        UNIQUEIDENTIFIER NOT NULL
);

