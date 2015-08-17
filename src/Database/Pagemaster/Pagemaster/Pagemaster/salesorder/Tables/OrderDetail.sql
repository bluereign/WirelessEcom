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

CREATE TRIGGER [salesorder].[tr_changes] ON [salesorder].[OrderDetail]
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