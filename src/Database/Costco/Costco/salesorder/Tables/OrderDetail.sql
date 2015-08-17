CREATE TABLE [salesorder].[OrderDetail] (
    [OrderDetailId]   INT            IDENTITY (1, 1) NOT NULL,
    [OrderDetailType] VARCHAR (1)    CONSTRAINT [DF__orderdeta__ow_ty__2062B9C8] DEFAULT ((0)) NULL,
    [OrderId]         INT            CONSTRAINT [DF__OrderDeta__Order__5CF6C6BC] DEFAULT ((0)) NULL,
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
    [Weight]          FLOAT (53)     NULL,
    [TotalWeight]     INT            CONSTRAINT [DF__OrderDeta__Total__658C0CBD] DEFAULT ((0)) NULL,
    [Taxable]         BIT            CONSTRAINT [DF_OrderDetails_Taxable] DEFAULT ((1)) NULL,
    [Taxes]           MONEY          NULL,
    [Message]         NVARCHAR (255) NULL,
    [ShipmentId]      INT            NULL,
    [RMANumber]       VARCHAR (50)   NULL,
    [RMAStatus]       INT            NULL,
    [RMAReason]       VARCHAR (50)   NULL,
    [Rebate]          MONEY          NULL,
    [DiscountTotal]   MONEY          NULL,
    CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED ([OrderDetailId] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OrderDetail_11_1242539560__K4_K6_K2_K14_K1_K3]
    ON [salesorder].[OrderDetail]([GroupNumber] ASC, [ProductId] ASC, [OrderDetailType] ASC, [NetPrice] ASC, [OrderDetailId] ASC, [OrderId] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OrderDetail_11_1242539560__K2_1_3_8_11]
    ON [salesorder].[OrderDetail]([OrderDetailType] ASC)
    INCLUDE([OrderDetailId], [OrderId], [GersSku], [Qty]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OrderDetail_11_1242539560__K2_K8_3]
    ON [salesorder].[OrderDetail]([OrderDetailType] ASC, [GersSku] ASC)
    INCLUDE([OrderId]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_OrderDetail_11_1242539560__K8_K3]
    ON [salesorder].[OrderDetail]([GersSku] ASC, [OrderId] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_OrderDetail]
    ON [salesorder].[OrderDetail]([OrderId] ASC, [OrderDetailId] ASC, [GroupName] ASC)
    INCLUDE([ProductId], [ProductTitle]) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_OrderDetailType_OrderId_OrderDetailId]
    ON [salesorder].[OrderDetail]([OrderDetailType] ASC, [OrderId] ASC, [OrderDetailId] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_OrderId_GroupNumber_OrderDetailId]
    ON [salesorder].[OrderDetail]([OrderId] ASC, [GroupNumber] ASC, [OrderDetailId] ASC) WITH (FILLFACTOR = 80);


GO
CREATE STATISTICS [_dta_stat_1242539560_1_8_3]
    ON [salesorder].[OrderDetail]([OrderDetailId], [GersSku], [OrderId]);


GO
CREATE STATISTICS [_dta_stat_1242539560_14_2]
    ON [salesorder].[OrderDetail]([NetPrice], [OrderDetailType]);


GO
CREATE STATISTICS [_dta_stat_1242539560_1_14_2_6]
    ON [salesorder].[OrderDetail]([OrderDetailId], [NetPrice], [OrderDetailType], [ProductId]);


GO
CREATE STATISTICS [_dta_stat_1242539560_2_1_3_4_14_6]
    ON [salesorder].[OrderDetail]([OrderDetailType], [OrderDetailId], [OrderId], [GroupNumber], [NetPrice], [ProductId]);


GO
CREATE STATISTICS [_dta_stat_1242539560_4_6_1_2_14]
    ON [salesorder].[OrderDetail]([GroupNumber], [ProductId], [OrderDetailId], [OrderDetailType], [NetPrice]);


GO
CREATE STATISTICS [_dta_stat_1242539560_6_1_2]
    ON [salesorder].[OrderDetail]([ProductId], [OrderDetailId], [OrderDetailType]);


GO
CREATE STATISTICS [_dta_stat_1242539560_6_2_14]
    ON [salesorder].[OrderDetail]([ProductId], [OrderDetailType], [NetPrice]);


GO
CREATE STATISTICS [_dta_stat_1242539560_4_14_2_3]
    ON [salesorder].[OrderDetail]([GroupNumber], [NetPrice], [OrderDetailType], [OrderId]);


GO
CREATE STATISTICS [_dta_stat_1242539560_3_1_4_14]
    ON [salesorder].[OrderDetail]([OrderId], [OrderDetailId], [GroupNumber], [NetPrice]);


GO
CREATE STATISTICS [_dta_stat_1242539560_3_8_2]
    ON [salesorder].[OrderDetail]([OrderId], [GersSku], [OrderDetailType]);


GO
CREATE STATISTICS [_dta_stat_1242539560_4_1_14_2]
    ON [salesorder].[OrderDetail]([GroupNumber], [OrderDetailId], [NetPrice], [OrderDetailType]);


GO

CREATE   TRIGGER [salesorder].[tr_changes] ON [salesorder].[OrderDetail]
    AFTER INSERT, UPDATE, DELETE
AS
    SET NOCOUNT ON 
    

DECLARE @type CHAR(1);

	IF EXISTS (SELECT * FROM inserted)
	IF EXISTS (SELECT * FROM deleted)
			SELECT @Type = 'U'
		ELSE
			SELECT @Type = 'I'
	ELSE
		SELECT @Type = 'D'

        
			IF @type = 'U' OR @type = 'I'
			    BEGIN
			    INSERT INTO logging.orderdetail
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderDetailId
				,OrderDetailType
				,OrderId
				,GroupNumber
				,GroupName
				,ProductId
				,GersSku
				,ProductTitle
				,PartNumber
				,Qty
				,COGS
				,RetailPrice
				,NetPrice
				,Weight
				,TotalWeight
				,Taxable
				,Taxes
				,Message
				,ShipmentId
				,RMANumber
				,RMAStatus
				,RMAReason
				,Rebate
				,DiscountTotal
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,@type
						,sod.OrderDetailId
						,sod.OrderDetailType
						,sod.OrderId
						,sod.GroupNumber
						,sod.GroupName
						,sod.ProductId
						,sod.GersSku
						,sod.ProductTitle
						,sod.PartNumber
						,sod.Qty
						,sod.COGS
						,sod.RetailPrice
						,sod.NetPrice
						,sod.Weight
						,sod.TotalWeight
						,sod.Taxable
						,sod.Taxes
						,sod.Message
						,sod.ShipmentId
						,sod.RMANumber
						,sod.RMAStatus
						,sod.RMAReason
						,sod.Rebate
						,sod.DiscountTotal
                    FROM
                        salesorder.[OrderDetail] sod
                        INNER JOIN inserted b ON sod.orderdetailid = b.orderdetailid
			    END 

			IF @type = 'D'
			    BEGIN
			    INSERT INTO logging.orderdetail
			    (ChangeDate
				,HostName
				,ServerName
				,UserName
				,Actions
				,OrderDetailId
				,OrderDetailType
				,OrderId
				,GroupNumber
				,GroupName
				,ProductId
				,GersSku
				,ProductTitle
				,PartNumber
				,Qty
				,COGS
				,RetailPrice
				,NetPrice
				,Weight
				,TotalWeight
				,Taxable
				,Taxes
				,Message
				,ShipmentId
				,RMANumber
				,RMAStatus
				,RMAReason
				,Rebate
				,DiscountTotal
				)
			        SELECT
                        GETDATE()
                        ,HOST_NAME()
                        ,@@servername
                        ,SYSTEM_USER
                        ,@type
						,b.OrderDetailId
						,b.OrderDetailType
						,b.OrderId
						,b.GroupNumber
						,b.GroupName
						,b.ProductId
						,b.GersSku
						,b.ProductTitle
						,b.PartNumber
						,b.Qty
						,b.COGS
						,b.RetailPrice
						,b.NetPrice
						,b.Weight
						,b.TotalWeight
						,b.Taxable
						,b.Taxes
						,b.Message
						,b.ShipmentId
						,b.RMANumber
						,b.RMAStatus
						,b.RMAReason
						,b.Rebate
						,b.DiscountTotal
                    FROM
                        deleted b
			    END
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1=Open, 2=Complete, 3=Cancelled', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'RMAStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ShipmentId related to the Shipment table. By default most OrderDetail items get the same ShipmentId. WOuld be different for split orders or RMAs', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ShipmentId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Specific message provided by the customer for this line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Message';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Calculated taxes for this line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Taxes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot if the product is taxable at the time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Taxable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Weight of the product * Qty', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'TotalWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Weight of the product.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Weight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product price after discounts.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'NetPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot of the product price sold on the website at the current time of the order.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'RetailPrice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Cost of Goods sold. Used to calculate taxes in some states such as California. ', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'COGS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Number of same items.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'Qty';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'TODO: What is this populated by?', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'PartNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Snapshot of the title at the time of the order. Is displayed on order summary and order confirmation screens.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ProductTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKU provided by the GERS system', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GersSku';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Coresponding Product.ProductID for the line item.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'ProductId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The alias of a group. Defaults to Line X, where X is the line number. Can be renamed to any alias by customer.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GroupName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Number coresponding to the Group of the order. A multi line order will have one or more groups. ', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'GroupNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The parent Order record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A=Acc,  R=Plan, D=Device, S=Service. Records with ''S'' relate to  LineService record. Records with ''R'' relate to a WirelessLine record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderDetailType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Primary Key for this OrderDetail record.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail', @level2type = N'COLUMN', @level2name = N'OrderDetailId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Extended (NOT per-unit) cost of goods sold.', @level0type = N'SCHEMA', @level0name = N'salesorder', @level1type = N'TABLE', @level1name = N'OrderDetail';

