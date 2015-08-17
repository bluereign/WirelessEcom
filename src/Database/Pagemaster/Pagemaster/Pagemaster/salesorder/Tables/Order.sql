CREATE TABLE [salesorder].[Order] (
    [OrderId]                       INT              IDENTITY (1, 1) NOT NULL,
    [OrderDate]                     DATETIME         NULL,
    [UserId]                        INT              NULL,
    [ShipAddressGuid]               UNIQUEIDENTIFIER NULL,
    [BillAddressGuid]               UNIQUEIDENTIFIER NULL,
    [EmailAddress]                  NVARCHAR (255)   NOT NULL,
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
    [SmsOptIn]                      BIT              CONSTRAINT [DF__Order__SmsOptIn__11561191] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__Orders__49E3F248] PRIMARY KEY CLUSTERED ([OrderId] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId_OrderDate_OrderId]
    ON [salesorder].[Order]([UserId] ASC, [OrderDate] ASC, [OrderId] ASC) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [_dta_stat_1834541669_1_12]
    ON [salesorder].[Order]([OrderId], [GERSStatus]);


GO
CREATE STATISTICS [_dta_stat_1834541669_11_1]
    ON [salesorder].[Order]([Status], [OrderId]);


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