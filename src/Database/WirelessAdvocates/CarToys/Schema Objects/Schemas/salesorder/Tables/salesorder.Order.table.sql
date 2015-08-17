CREATE TABLE [salesorder].[Order] (
    [OrderId]                       INT              IDENTITY (1, 1) NOT NULL,
    [OrderDate]                     DATETIME         NULL,
    [UserId]                        INT              NULL,
    [ShipAddressGuid]               UNIQUEIDENTIFIER NULL,
    [BillAddressGuid]               UNIQUEIDENTIFIER NULL,
    [EmailAddress]                  NVARCHAR (255)   NULL,
    [ShipMethodId]                  INT              NULL,
    [ActivationType]                VARCHAR (1)      NULL,
    [Message]                       NVARCHAR (254)   NULL,
    [IPaddress]                     VARCHAR (39)     NULL,
    [Status]                        INT              NULL,
    [GERSStatus]                    INT              NULL,
    [GERSRefNum]                    VARCHAR (14)     NULL,
    [TimeSentToGERS]                DATETIME         NULL,
    [ShipCost]                      MONEY            NULL,
    [CarrierId]                     INT              NULL,
    [CheckoutReferenceNumber]       VARCHAR (50)     NULL,
    [SalesTaxTransactionId]         VARCHAR (50)     NULL,
    [IsSalesTaxTransactionCommited] BIT              DEFAULT ((0)) NOT NULL,
    [SalesTaxRefundTransactionId]   VARCHAR (50)     NULL,
    [SortCode]                      VARCHAR (3)      NULL,
    [ParentOrderId]                 INT              NULL,
    [DiscountTotal]                 MONEY            NULL,
    [DiscountCode]                  NVARCHAR (50)    NULL,
    [OrderAssistanceUsed]           BIT              DEFAULT ((0)) NOT NULL,
    [IsCreditCheckPending]          BIT              DEFAULT ((0)) NULL,
    [CreditApplicationNumber]       VARCHAR (50)     NULL,
    [CreditCheckStatusCode]         VARCHAR (10)     NULL,
    [ServiceZipCode]                VARCHAR (10)     NULL,
    [KioskEmployeeNumber]           NVARCHAR (50)    NULL,
    [ShipmentDeliveryDate]          DATE             NULL,
    [PcrDate]                       DATETIME         NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary Key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DateTime the order was placed.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id of the user in relation to the Users.Id', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Ship Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Billing Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'BillAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Users email address at the time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'EmailAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Selected ship method for the order. Relates to the ShipMethod table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipMethodId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N=New, U=Upgrade, A=AddALine (New Multiline is still a value of N)', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ActivationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer supplied message in the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP address logged by the system.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'IPaddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = Pending, 1 = Submitted, 2 = Payment Complete, 3 = Closed, 4 = Cancelled; 5 = Transaction Failed', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'-1 = weblink failed, 0 = default, 1= sent, 2 = succes', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GERS confirmation number. When this number is available, the GERS order has been created.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSRefNum';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date time the order was sent to GIRS', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'TimeSentToGERS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total shipping cost of order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipCost';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: Move to WirelessAccount', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique reference number created at checkout. Is used to store values in the session state.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CheckoutReferenceNumber';

