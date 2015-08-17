SET NOCOUNT ON
GO

BEGIN TRANSACTION

/**************************************************************************************
* MOVE PROMOTIONS NAVIGATION ITEM UNDER CONTENT MANAGEMENT
*/
	PRINT 'START - Move Promotion navigation item under Content Management'
	
	DECLARE @ParentId UNIQUEIDENTIFIER

	SELECT @ParentId = AdminMenuId
	FROM AdminMenu 
	WHERE Label = 'Content Management'

	UPDATE AdminMenu
	SET	
		Ordinal = ( SELECT MAX(Ordinal)+1 FROM AdminMenu WHERE ParentId = @ParentId )
		,ParentId = @ParentId
	WHERE Label = 'Promotions'
	
	PRINT 'END - Move Promotion navigation item under Content Management'
	GO

/**************************************************************************************
* DROP CONSTRAINTS THAT EXISTED IN THE FIRST VERSION OF THIS SCRIPT BUT HAVE SINCE BEEN REMOVED/RENAMED
*/

	PRINT 'START - Cleanup of previous script'
	GO

	IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[PROMOTION].[fk_PromotionOperator]') AND parent_object_id = OBJECT_ID(N'[PROMOTION].[Condition]'))
		ALTER TABLE [PROMOTION].[Condition] DROP CONSTRAINT [fk_PromotionOperator]
		
	IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[catalog].[fk_PromotionDiscountType]') AND parent_object_id = OBJECT_ID(N'[catalog].[PromotionCodes]'))
		ALTER TABLE [catalog].[PromotionCodes] DROP CONSTRAINT [fk_PromotionDiscountType]
	
	IF  EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[PROMOTION].[fk_AppliedToOrderDetail]') AND parent_object_id = OBJECT_ID(N'[PROMOTION].[Applied]'))
		ALTER TABLE [PROMOTION].[Applied] DROP CONSTRAINT [fk_AppliedToOrderDetail]
	
	IF  EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[PROMOTION].[fk_AppliedToPromotionCode]') AND parent_object_id = OBJECT_ID(N'[PROMOTION].[Applied]'))
		ALTER TABLE [PROMOTION].[Applied] DROP CONSTRAINT [fk_AppliedToPromotionCode]
		
	IF EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'PromotionCodes' )
	BEGIN
		PRINT 'Dropping [catalog].[PromotionCodes]'
		DROP TABLE [catalog].[PromotionCodes]
	END
	
    
    PRINT 'END  - Cleanup of previous script'
    GO
    
/**************************************************************************************
*  DROP ALL CONSTRAINTS AND TABLES CREATED BY THIS SCRIPT
*/
	PRINT 'START - Drop promotion tables'
	GO
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'service' AND TABLE_NAME = 'PromotionLog' )
	BEGIN
		PRINT 'Dropping [service].[PromotionLog]'
		ALTER TABLE [service].[PromotionLog] DROP CONSTRAINT [fk_PromoLogMatched]
		ALTER TABLE [service].[PromotionLog] DROP CONSTRAINT [fk_PromoLogProducts]
		ALTER TABLE [service].[PromotionLog] DROP CONSTRAINT [fk_PromoLogUser]
		DROP TABLE [service].[PromotionLog]
	END
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'PromotionCode' )
	BEGIN
		PRINT 'Dropping [catalog].[PromotionCode]'
		ALTER TABLE [catalog].[PromotionCode] DROP CONSTRAINT [fk_CodePromotion]
		DROP TABLE [catalog].[PromotionCode]
	END
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'PromotionProducts' )
	BEGIN
		ALTER TABLE [catalog].[PromotionProducts] DROP CONSTRAINT fk_Products
		PRINT 'Dropping [catalog].[PromotionProducts]'
		DROP TABLE [catalog].[PromotionProducts]
	END

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'RemainingQuantity' )
	BEGIN
		ALTER TABLE [promotion].[RemainingQuantity] DROP CONSTRAINT fk_Promotions
		PRINT 'Dropping [promotion].[RemainingQuantity]'
		DROP TABLE [promotion].[RemainingQuantity]
	END
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'Applied' )
	BEGIN
		ALTER TABLE [promotion].[Applied] DROP CONSTRAINT fk_PromotionCodes
		ALTER TABLE [promotion].[Applied] DROP CONSTRAINT fk_Users
		ALTER TABLE [promotion].[Applied] DROP CONSTRAINT fk_Orders
		PRINT 'Dropping [promotion].[Applied]'
		DROP TABLE [promotion].[Applied]
	END
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'Condition' )
	BEGIN
		IF OBJECT_ID('fk_PromotionCode', 'C') IS NOT NULL 
			ALTER TABLE [promotion].[Condition] DROP CONSTRAINT fk_PromotionCode
		
		PRINT 'Dropping [promotion].[Condition]'
		DROP TABLE [promotion].[Condition]
	END
	
	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'Promotion' )
	BEGIN
		ALTER TABLE [catalog].[Promotion] DROP CONSTRAINT df_MaxQuantityPerUser 
		ALTER TABLE [catalog].[Promotion] DROP CONSTRAINT fk_PromotionDiscountType
		PRINT 'Dropping [catalog].[Promotion]'
		DROP TABLE [catalog].[Promotion] 
	END

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'Category' )
	BEGIN
		PRINT 'Dropping [promotion].[Category]'
		DROP TABLE [promotion].[Category]
	END

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'DiscountType' )
	BEGIN
		PRINT 'Dropping [promotion].[DiscountType]'
		DROP TABLE [promotion].[DiscountType] 
	END

	PRINT 'END - Drop promotion tables'
	GO
	
/**************************************************************************************
*  MODIFY EXISTING TABLES
*/

IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'salesOrder' AND TABLE_NAME = 'OrderDetail' AND COLUMN_NAME = 'DiscountTotal' )
	ALTER TABLE [salesOrder].[OrderDetail] ADD DiscountTotal MONEY NULL

/**************************************************************************************
*  CREATE AND POPULATE NEW TABLES
*/
	PRINT 'START - Create and populate promotion tables'
	GO

	/****************************************
	*	Promotion Category: How/when to apply discount
	****************************************/
	CREATE TABLE [promotion].[Category] (
		PromotionCategoryId INT PRIMARY KEY IDENTITY
		,Name NVARCHAR(50)
	)

	INSERT INTO [promotion].[Category] (Name)
	VALUES ('Accessory')
		,('Device')
		,('Shipping')

	/****************************************
	*	Discount Type: Whether value of discount is a flat reduction or %
	****************************************/
	CREATE TABLE [promotion].[DiscountType] (
		DiscountTypeId INT PRIMARY KEY IDENTITY
		,Name NVARCHAR(10)
		)

	INSERT INTO [promotion].[DiscountType](Name)
	VALUES ('Percent')
		,('Flat')

	/****************************************
	*	Generic promotion table
	*   NH: keeping this in the catalog schema so that promotion codes can be channelized and maintained by Merch
	*   Since I want to keep this information "channelizable" I will create a separate table that monitors the
	*   remainder of the codes.
	****************************************/
	CREATE TABLE [catalog].[Promotion] (
		PromotionId INT PRIMARY KEY IDENTITY
		,Name VARCHAR(255) NOT NULL
		,Discount DECIMAL(5, 2) --This represents a dollar amount or percentage (0.20 == 20%)
		,ShippingMethodId INT CONSTRAINT fk_ShippingMethod FOREIGN KEY REFERENCES [salesorder].ShipMethod(ShipMethodId)
		,MaxQuantity INT --Total number of times this code can be used
		,MaxQuantityPerUser INT CONSTRAINT df_MaxQuantityPerUser DEFAULT(1)
		,StartDate DATETIME
		,EndDate DATETIME
		,DiscountTypeId INT CONSTRAINT fk_PromotionDiscountType FOREIGN KEY REFERENCES [promotion].DiscountType(DiscountTypeId)
		,CreatedDate DATETIME NOT NULL
		,DeletedDate DATETIME NULL
		)
	
	/*****************************************
	*	Code m2o for Promotions
	*****************************************/
	CREATE TABLE [catalog].[PromotionCode] (
		PromotionCodeId INT PRIMARY KEY IDENTITY
		,Code NVARCHAR(20) NOT NULL CONSTRAINT uc_Code UNIQUE
		,PromotionId INT CONSTRAINT fk_CodePromotion FOREIGN KEY REFERENCES [catalog].[Promotion]
		)
	CREATE INDEX idx_PromotionCode ON [catalog].[PromotionCode](Code)

	
	/****************************************
	*	Remaining Quantity: Designates remaining number of times a promotion id can be applied to an order
	****************************************/
	CREATE TABLE [promotion].[RemainingQuantity] (
		PromotionDurationId INT PRIMARY KEY IDENTITY
		,PromotionId INT CONSTRAINT fk_Promotions FOREIGN KEY REFERENCES [catalog].[Promotion](PromotionId)
		,RemainingQuantity INT --MaxQuantity from [catalog].Promotion less the number of times it has been applied
		)

	/****************************************
	*	Promotion Used: Records the use of promotions per user account
	****************************************/
	CREATE TABLE [promotion].[Applied] (
		PromotionAppliedId INT PRIMARY KEY IDENTITY
		,PromotionId INT NOT NULL CONSTRAINT fk_PromotionCodes FOREIGN KEY REFERENCES [catalog].[Promotion](PromotionId)
		,UserId INT NOT NULL CONSTRAINT fk_Users FOREIGN KEY REFERENCES [dbo].Users([User_ID])
		,OrderId INT NOT NULL CONSTRAINT fk_Orders FOREIGN KEY REFERENCES [salesorder].[Order](OrderId)
		,OrderDetailId INT NULL CONSTRAINT fk_AppliedToOrderDetail FOREIGN KEY REFERENCES salesorder.OrderDetail
		,PromotionCodeId INT NOT NULL CONSTRAINT fk_AppliedToPromotionCode FOREIGN KEY REFERENCES [catalog].PromotionCode
		,Value VARCHAR(10) NOT NULL
		,ApplyDate DATETIME NOT NULL
		)

	/****************************************
	*	Promotion Condition: Stores the logic to determine whether discount applies by quantity or price
	****************************************/
	CREATE TABLE [promotion].[Condition] (
		PromotionConditionId INT PRIMARY KEY IDENTITY
		,PromotionID INT NOT NULL CONSTRAINT fk_PromotionCode FOREIGN KEY REFERENCES [catalog].Promotion(PromotionId)
		,OrderTotal MONEY NULL
		,OrderTotalOptional BIT NULL
		,OrderQuantity INT NULL
		,OrderQuantityOptional BIT NULL
		,OrderSKUsOptional BIT NULL
		,AccessoryTotal MONEY NULL
		,AccessoryTotalOptional BIT NULL
		,AccessoryQuantity INT NULL
		,AccessoryQuantityOptional BIT NULL
		)
		
	/****************************************
	*	Promotion Products: Maintains reference of promotion to product
	*   NH: keeping this in the catalog schema so that items for promotion can be channelized and maintained by Merch
	****************************************/
	CREATE TABLE [catalog].[PromotionProducts] (
		PromotionItemId INT PRIMARY KEY IDENTITY
		,PromotionId INT NULL CONSTRAINT fk_PromotionCodes FOREIGN KEY REFERENCES [catalog].Promotion(PromotionId)
		,ConditionId INT NULL CONSTRAINT fk_PromotionCondition FOREIGN KEY REFERENCES [promotion].[Condition](PromotionConditionId)
		,GersSku NVARCHAR(9) NOT NULL CONSTRAINT fk_Products FOREIGN KEY REFERENCES [catalog].[GersItm](GersSku)
		)
	
	/****************************************
	*	Promotion Log: Records attempts to apply promotion to cart
	****************************************/
	CREATE TABLE [service].[PromotionLog] (
		PromotionLogId INT PRIMARY KEY IDENTITY
		,Code NVARCHAR(20) NOT NULL
		,Passed BIT NOT NULL
		,UserId INT NOT NULL CONSTRAINT fk_PromoLogUser FOREIGN KEY REFERENCES [dbo].Users([User_ID])
		,PromotionId INT NULL CONSTRAINT fk_PromoLogMatched FOREIGN KEY REFERENCES [catalog].[Promotion]([PromotionId])
		,Msg VARCHAR(255) NOT NULL 
		,Discount MONEY NULL
		,DiscountFrom NVARCHAR(20)NULL
		,GersSku NVARCHAR(9) NULL CONSTRAINT fk_PromoLogProducts FOREIGN KEY REFERENCES [catalog].[GersItm](GersSku)
		,CreatedDate DATETIME DEFAULT GETDATE()
	)
		
	PRINT 'END - Create and populate promotion tables'

SET NOCOUNT OFF

COMMIT TRANSACTION

PRINT 'SCRIPT END'