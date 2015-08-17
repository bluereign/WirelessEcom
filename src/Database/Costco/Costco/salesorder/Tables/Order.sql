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
    [IsSalesTaxTransactionCommited] BIT              DEFAULT ((0)) NOT NULL,
    [SalesTaxRefundTransactionId]   VARCHAR (50)     NULL,
    [SortCode]                      VARCHAR (3)      NULL,
    [ParentOrderId]                 INT              NULL,
    [DiscountTotal]                 MONEY            NULL,
    [DiscountCode]                  INT              NULL,
    [OrderAssistanceUsed]           BIT              DEFAULT ((0)) NOT NULL,
    [IsCreditCheckPending]          BIT              DEFAULT ((0)) NULL,
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
    CONSTRAINT [PK__Orders__49E3F248] PRIMARY KEY CLUSTERED ([OrderId] ASC) WITH (FILLFACTOR = 90),
    FOREIGN KEY ([DiscountCode]) REFERENCES [catalog].[Coupon] ([CouponId]),
    CONSTRAINT [fk_PaymentGatewayType] FOREIGN KEY ([PaymentGatewayId]) REFERENCES [service].[PaymentGatewayType] ([PaymentGatewayId])
);


GO
CREATE NONCLUSTERED INDEX [IDX_Order_GSO]
    ON [salesorder].[Order]([GERSStatus] ASC, [Status] ASC, [OrderId] ASC)
    INCLUDE([ActivationType]);


GO
CREATE NONCLUSTERED INDEX [IDX_Order_SG]
    ON [salesorder].[Order]([Status] ASC, [GERSStatus] ASC)
    INCLUDE([OrderId], [GERSRefNum], [TimeSentToGERS]);


GO
CREATE NONCLUSTERED INDEX [IDX_Order_SS]
    ON [salesorder].[Order]([ShipAddressGuid] ASC, [ShipmentDeliveryDate] ASC)
    INCLUDE([OrderId], [ShipMethodId]);


GO
CREATE NONCLUSTERED INDEX [IDX_Order]
    ON [salesorder].[Order]([Status] ASC, [GERSStatus] ASC, [ShipAddressGuid] ASC, [OrderId] ASC, [ShipMethodId] ASC)
    INCLUDE([OrderDate], [UserId], [EmailAddress], [ActivationType], [Message], [ShipCost], [SortCode], [ParentOrderId]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_UserId_OrderDate_OrderId]
    ON [salesorder].[Order]([UserId] ASC, [OrderDate] ASC, [OrderId] ASC);


GO
CREATE STATISTICS [_dta_stat_1834541669_1_12]
    ON [salesorder].[Order]([OrderId], [GERSStatus]);


GO
CREATE STATISTICS [_dta_stat_1834541669_11_1]
    ON [salesorder].[Order]([Status], [OrderId]);


GO

---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_status_modify
-- Description : Insert into a table whenever the status is updated, intended to help identify why old untouched orders suddenly flow through the system as active.
-- Author : Naomi Hall
-- Date : December 17th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_gersstatus_modify] ON [salesorder].[Order]
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
DISABLE TRIGGER [salesorder].[tr_gersstatus_modify]
    ON [salesorder].[Order];


GO
CREATE TRIGGER [salesorder].[ValidateGersStatusUpdates]
	ON [salesorder].[Order]
	AFTER UPDATE
AS
	IF(UPDATE(GersStatus))
	BEGIN
		DECLARE @RevertedUpdates TABLE (
			OrderId int,
			OldGersStatus int,
			NewGersStatus int
			)
		;

		UPDATE O
		SET GERSStatus = D.GERSStatus
		OUTPUT inserted.OrderId, inserted.GERSStatus, deleted.GERSStatus INTO @RevertedUpdates
		FROM salesorder.[Order] O
			INNER JOIN deleted D ON O.OrderId = D.OrderId
			INNER JOIN inserted I ON O.OrderId = I.OrderId
		WHERE D.[Status] = 3
			AND D.GERSStatus > 0
			AND I.GERSStatus < D.GERSStatus
			AND I.GERSStatus != -1
		;

		INSERT INTO salesorder.Activity (
			OrderId
			, Name
			, [Description]
			)
		SELECT OrderId
			, 'GersStatus Update Reverted'
			, 'User ''' + SYSTEM_USER + ''' attempted to update GersStatus from ' + CONVERT(nvarchar,OldGersStatus) + ' to ' + CONVERT(nvarchar,NewGersStatus) + ' using ''' + APP_NAME() + '''.'
		FROM @RevertedUpdates
		;

		IF (@@ROWCOUNT > 0)
		BEGIN
			RAISERROR (
				N'An invalid update to GersStatus has been reverted. See the salesorder.Activity table for details.' -- Message text
				, 16 -- Severity
				, 1 -- State
			)
			;
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

CREATE TRIGGER [salesorder].[tr_status_modify] ON [salesorder].[Order]
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
                        INNER JOIN inserted b ON so.orderid = b.orderid
			    END 
		END
GO
DISABLE TRIGGER [salesorder].[tr_status_modify]
    ON [salesorder].[Order];


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_shipcost_modify
-- Description : Insert into a table whenever the shipping cost is updated, trigger activated when we enable shipping promos like free over night
-- Author : Naomi Hall
-- Date : December 12th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_shipcost_modify] ON [salesorder].[Order]
    AFTER UPDATE
AS
    SET NOCOUNT ON 
        
    IF (UPDATE(ShipCost))
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
DISABLE TRIGGER [salesorder].[tr_shipcost_modify]
    ON [salesorder].[Order];


GO
---------------------------------------------------------------------------- 
-- Object Type : Trigger
-- Object Name : msdb.tr_neworder_insert
-- Description : Retain original order information
-- Author : NH
-- Date : September 24th, 2012
---------------------------------------------------------------------------- 

CREATE TRIGGER [salesorder].[tr_neworder_insert] ON [salesorder].[Order]
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
DISABLE TRIGGER [salesorder].[tr_neworder_insert]
    ON [salesorder].[Order];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Unique reference number created at checkout. Is used to store values in the session state.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CheckoutReferenceNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: Move to WirelessAccount', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'CarrierId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total shipping cost of order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipCost';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date time the order was sent to GIRS', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'TimeSentToGERS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'GERS confirmation number. When this number is available, the GERS order has been created.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSRefNum';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' -1 = weblink failed, 0 = default, 1= sent, 2 = succes', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'GERSStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 = Pending, 1 = Submitted, 2 = Payment Complete, 3 = Closed, 4 = Cancelled; 5 = Transaction Failed', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP address logged by the system.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'IPaddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Customer supplied message in the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N=New, U=Upgrade, A=AddALine (New Multiline is still a value of N)', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ActivationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Selected ship method for the order. Relates to the ShipMethod table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipMethodId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Users email address at the time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'EmailAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Billing Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'BillAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Order Ship Address GUID. Relates to the Address table.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'ShipAddressGuid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id of the user in relation to the Users.Id', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'UserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DateTime the order was placed.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary Key', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'Order', @level2type = N'COLUMN', @level2name = N'OrderId';

