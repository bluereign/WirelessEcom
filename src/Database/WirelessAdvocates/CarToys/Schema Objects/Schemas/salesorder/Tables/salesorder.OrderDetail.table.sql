CREATE TABLE [salesorder].[OrderDetail] (
    [OrderDetailId]   INT            IDENTITY (1, 1) NOT NULL,
    [OrderDetailType] VARCHAR (1)    NULL,
    [OrderId]         INT            NULL,
    [GroupNumber]     INT            NULL,
    [GroupName]       NVARCHAR (50)  NULL,
    [ProductId]       INT            NULL,
    [GersSku]         VARCHAR (9)    NULL,
    [ProductTitle]    VARCHAR (500)  NULL,
    [PartNumber]      NVARCHAR (50)  NULL,
    [Qty]             INT            NULL,
    [COGS]            MONEY          NULL,
    [RetailPrice]     MONEY          NULL,
    [NetPrice]        MONEY          NULL,
    [Weight]          FLOAT          NULL,
    [TotalWeight]     INT            NULL,
    [Taxable]         BIT            NULL,
    [Taxes]           MONEY          NULL,
    [Message]         NVARCHAR (255) NULL,
    [ShipmentId]      INT            NULL,
    [RMANumber]       VARCHAR (50)   NULL,
    [RMAStatus]       INT            NULL,
    [RMAReason]       VARCHAR (50)   NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Extended (NOT per-unit) cost of goods sold.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary Key for this OrderDetail record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A=Acc,  R=Plan, D=Device, S=Service. Records with ''S'' relate to  LineService record. Records with ''R'' relate to a WirelessLine record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderDetailType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The parent Order record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Number coresponding to the Group of the order. A multi line order will have one or more groups.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GroupNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The alias of a group. Defaults to Line X, where X is the line number. Can be renamed to any alias by customer.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Coresponding Product.ProductID for the line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ProductId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKU provided by the GERS system', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GersSku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot of the title at the time of the order. Is displayed on order summary and order confirmation screens.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ProductTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: What is this populated by?', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'PartNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Number of same items.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Qty';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cost of Goods sold. Used to calculate taxes in some states such as California.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'COGS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot of the product price sold on the website at the current time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'RetailPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product price after discounts.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'NetPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Weight of the product.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Weight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Weight of the product * Qty', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'TotalWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot if the product is taxable at the time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Taxable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculated taxes for this line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Taxes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specific message provided by the customer for this line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ShipmentId related to the Shipment table. By default most OrderDetail items get the same ShipmentId. WOuld be different for split orders or RMAs', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ShipmentId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1=Open, 2=Complete, 3=Cancelled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'RMAStatus';

