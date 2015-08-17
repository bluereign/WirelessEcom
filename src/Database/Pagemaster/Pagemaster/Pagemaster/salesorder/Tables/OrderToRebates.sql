CREATE TABLE [salesorder].[OrderToRebates] (
    [OrderToRebateGuid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [OrderId]           INT              NOT NULL,
    [RebateGuid]        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_OrderToRebates] PRIMARY KEY CLUSTERED ([OrderToRebateGuid] ASC) WITH (FILLFACTOR = 80)
);

