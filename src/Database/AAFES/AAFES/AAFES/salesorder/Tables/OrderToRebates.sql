CREATE TABLE [salesorder].[OrderToRebates] (
    [OrderToRebateGuid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [OrderId]           INT              NOT NULL,
    [RebateGuid]        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_OrderToRebates] PRIMARY KEY CLUSTERED ([OrderToRebateGuid] ASC) WITH (FILLFACTOR = 80)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderToRebates', @level2type = N'COLUMN', @level2name = N'OrderToRebateGuid';

