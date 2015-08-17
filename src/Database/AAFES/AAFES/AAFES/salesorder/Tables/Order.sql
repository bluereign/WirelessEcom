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
    [Status]                        INT              CONSTRAINT [DF__Orders__Status__4EA8A765] DEFAULT ((0)) NULL,
    [GERSStatus]                    INT              CONSTRAINT [DF_Orders_SentToGERS] DEFAULT ((0)) NULL,
    [GERSRefNum]                    VARCHAR (14)     NULL,
    [TimeSentToGERS]                DATETIME         NULL,
    [ShipCost]                      MONEY            NULL,
    [CarrierId]                     INT              NULL,
    [CheckoutReferenceNumber]       VARCHAR (50)     NULL,
    [SalesTaxTransactionId]         VARCHAR (50)     NULL,
    [IsSalesTaxTransactionCommited] BIT              CONSTRAINT [DF__Order__IsSalesTa__739BCBA0] DEFAULT ((0)) NOT NULL,
    [SalesTaxRefundTransactionId]   VARCHAR (50)     NULL,
    [SortCode]                      VARCHAR (3)      NULL,
    [ParentOrderId]                 INT              NULL,
    [DiscountTotal]                 MONEY            NULL,
    [DiscountCode]                  INT              NULL,
    [OrderAssistanceUsed]           BIT              CONSTRAINT [DF__Order__OrderAssi__754F09E8] DEFAULT ((0)) NOT NULL,
    [IsCreditCheckPending]          BIT              CONSTRAINT [DF__Order__IsCreditC__07B96994] DEFAULT ((0)) NULL,
    [CreditApplicationNumber]       VARCHAR (50)     NULL,
    [CreditCheckStatusCode]         VARCHAR (10)     NULL,
    [ServiceZipCode]                VARCHAR (10)     NULL,
    [KioskEmployeeNumber]           NVARCHAR (50)    NULL,
    [ShipmentDeliveryDate]          DATE             NULL,
    [PcrDate]                       DATETIME         NULL,
    [LockDateTime]                  DATETIME         NULL,
    [LockedById]                    INT              NULL,
    [PaymentCapturedById]           INT              NULL,
    [ActivatedById]                 INT              NULL,
    [CreditCheckKeyInfoId]          INT              NULL,
    [PaymentGatewayId]              INT              NULL,
    [CarrierConversationId]         VARCHAR (100)    NULL,
    [CampaignId]                    INT              NULL,
    [SmsOptIn]                      BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Orders__49E3F248] PRIMARY KEY CLUSTERED ([OrderId] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK__Order__DiscountC__1C63D8D7] FOREIGN KEY ([DiscountCode]) REFERENCES [catalog].[Coupon] ([CouponId]),
    CONSTRAINT [fk_PaymentGatewayType] FOREIGN KEY ([PaymentGatewayId]) REFERENCES [service].[PaymentGatewayType] ([PaymentGatewayId])
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId_OrderDate_OrderId]
    ON [salesorder].[Order]([UserId] ASC, [OrderDate] ASC, [OrderId] ASC) WITH (FILLFACTOR = 80);


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_status_modify
-- Description : Insert into a table whenever the status is updated, intended to help identify why old untouched orders suddenly flow through the system as active.
-- Author : Naomi Hall
-- Date : December 17th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_gersstatus_modify] ON salesorder.[Order]
    AFTER UPDATE
AS
    SET NOCOUNT ON 
        
    IF (UPDATE(GersStatus))
        BEGIN
			IF EXISTS(SELECT 1 FROM deleted D)
			    BEGIN
			    INSERT INTO logging.orders
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderId
				,GERSRefNum
				,OrderDate
				,CarrierId
				,ActivationType
				,ShipMethodId
				,ShipCost
				,Status
				,GERSStatus
				,TimeSentToGERS
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,'UPDATE'
                        ,so.OrderId
                        ,so.GERSRefNum
                        ,so.OrderDate
                        ,so.CarrierId
                        ,so.ActivationType
                        ,so.ShipMethodId
                        ,so.ShipCost
                        ,so.Status
                        ,so.GERSStatus
                        ,so.TimeSentToGERS
                    FROM
                        salesorder.[Order] so
                        INNER JOIN inserted b ON so.orderid = b.orderid
			    END 
		END
GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_neworder_insert
-- Description : E-mail me when a new order is placed so we know original shipping method and costs
-- Author : NH
-- Date : September 24th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_neworder_insert] ON salesorder.[Order]
    AFTER INSERT
AS
    SET NOCOUNT ON 
        
    IF (UPDATE(OrderId))
        BEGIN
			IF EXISTS(SELECT 1 FROM inserted I)
			    BEGIN
			    INSERT INTO logging.orders
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderId
				,GERSRefNum
				,OrderDate
				,CarrierId
				,ActivationType
				,ShipMethodId
				,ShipCost
				,Status
				,GERSStatus
				,TimeSentToGERS
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,'INSERT'
                        ,so.OrderId
                        ,so.GERSRefNum
                        ,so.OrderDate
                        ,so.CarrierId
                        ,so.ActivationType
                        ,so.ShipMethodId
                        ,so.ShipCost
                        ,so.Status
                        ,so.GERSStatus
                        ,so.TimeSentToGERS
                    FROM
                        salesorder.[Order] so
                        INNER JOIN inserted b ON so.orderid = b.orderid
			    END 
		END
GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_status_modify
-- Description : Insert into a table whenever the status is updated, intended to help identify why old untouched orders suddenly flow through the system as active.
-- Author : Naomi Hall
-- Date : December 17th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_status_modify] ON salesorder.[Order]
    AFTER UPDATE
AS
    SET NOCOUNT ON 
        
    IF (UPDATE(Status))
        BEGIN
			IF EXISTS(SELECT 1 FROM deleted D)
			    BEGIN
			    INSERT INTO logging.orders
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderId
				,GERSRefNum
				,OrderDate
				,CarrierId
				,ActivationType
				,ShipMethodId
				,ShipCost
				,Status
				,GERSStatus
				,TimeSentToGERS
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,'UPDATE'
                        ,so.OrderId
                        ,so.GERSRefNum
                        ,so.OrderDate
                        ,so.CarrierId
                        ,so.ActivationType
                        ,so.ShipMethodId
                        ,so.ShipCost
                        ,so.Status
                        ,so.GERSStatus
                        ,so.TimeSentToGERS
                    FROM
                        salesorder.[Order] so
                        INNER JOIN inserted I ON so.orderid = I.orderid
			    END 
		END
GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_shipcost_modify
-- Description : Insert into a table whenever the shipping cost is updated, trigger activated when we enable shipping promos like free over night
-- Author : Naomi Hall
-- Date : December 12th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_shipcost_modify] ON salesorder.[Order]
    AFTER UPDATE
AS
    SET NOCOUNT ON 
        
    IF (UPDATE(ShipCost))
        BEGIN
			IF EXISTS(SELECT 1 FROM inserted I)
			    BEGIN
			    INSERT INTO logging.orders
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderId
				,GERSRefNum
				,OrderDate
				,CarrierId
				,ActivationType
				,ShipMethodId
				,ShipCost
				,Status
				,GERSStatus
				,TimeSentToGERS
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,'UPDATE'
                        ,so.OrderId
                        ,so.GERSRefNum
                        ,so.OrderDate
                        ,so.CarrierId
                        ,so.ActivationType
                        ,so.ShipMethodId
                        ,so.ShipCost
                        ,so.Status
                        ,so.GERSStatus
                        ,so.TimeSentToGERS
                    FROM
                        salesorder.[Order] so
                        INNER JOIN inserted b ON so.orderid = b.orderid
			    END 
		END
GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'SalesTaxTransactionId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CheckoutReferenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique reference number created at checkout. Is used to store values in the session state.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CheckoutReferenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: Move to WirelessAccount', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'Bug', @value = N'TODO: Move to WirelessAccount', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipCost';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total shipping cost of order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipCost';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'TimeSentToGERS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date time the order was sent to GIRS', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'TimeSentToGERS';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSRefNum';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GERS confirmation number. When this number is available, the GERS order has been created.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSRefNum';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' -1 = weblink failed, 0 = default, 1= sent, 2 = succes', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSStatus';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = Pending, 1 = Submitted, 2 = Payment Complete, 3 = Closed, 4 = Cancelled; 5 = Transaction Failed', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'IPaddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP address logged by the system.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'IPaddress';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer supplied message in the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ActivationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N=New, U=Upgrade, A=AddALine (New Multiline is still a value of N)', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ActivationType';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipMethodId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Selected ship method for the order. Relates to the ShipMethod table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipMethodId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'EmailAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Users email address at the time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'EmailAddress';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'BillAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Billing Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'BillAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Ship Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id of the user in relation to the Users.Id', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DateTime the order was placed.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderDate';


GO
EXECUTE sp_addextendedproperty @name = N'Owner', @value = N'UNKNOWN DBA.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderId';

