USE [AAFES.DEV]

SET NOCOUNT ON
GO

/**************************************************************************************
*  DROP ALL CONSTRAINTS AND TABLES CREATED BY THIS SCRIPT
*/
	PRINT 'START - Drop promotion tables'
	GO

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

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'PromotionCodes' )
	BEGIN
		ALTER TABLE [catalog].[PromotionCodes] DROP CONSTRAINT df_MaxQuantityPerUser 
		ALTER TABLE [catalog].[PromotionCodes] DROP CONSTRAINT df_MaxQuantityPerOrder
		ALTER TABLE [catalog].[PromotionCodes] DROP CONSTRAINT fk_PromotionDiscountType
		PRINT 'Dropping [catalog].[PromotionCodes]'
		DROP TABLE [catalog].[PromotionCodes] 
	END

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'Condition' )
	BEGIN
		ALTER TABLE [promotion].[Condition] DROP CONSTRAINT fk_PromotionOperator
		PRINT 'Dropping [promotion].[Condition]'
		DROP TABLE [promotion].[Condition]
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

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'promotion' AND TABLE_NAME = 'Operator' )
	BEGIN
		PRINT 'Dropping [promotion].[Operator]'
		DROP TABLE [promotion].[Operator] 
	END

	IF EXISTS ( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'catalog' AND TABLE_NAME = 'PromotionProducts' )
	BEGIN
		ALTER TABLE [catalog].[PromotionProducts] DROP CONSTRAINT fk_Products
		PRINT 'Dropping [catalog].[PromotionProducts]'
		DROP TABLE [catalog].[PromotionProducts]
	END

	PRINT 'END - Drop promotion tables'
	GO

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
	*	Promotion Operator: Reference table of logical comparison operators
	****************************************/
	CREATE TABLE [promotion].[Operator] (
		OperatorId INT PRIMARY KEY IDENTITY
		,Name NVARCHAR(20)
		)

	INSERT INTO [promotion].[Operator]( Name )
	VALUES ('Less than')
		,('Greater than')
		,('Equal to')

	/****************************************
	*	Generic promotion table
	*   NH: keeping this in the catalog schema so that promotion codes can be channelized and maintained by Merch
	*   Since I want to keep this information "channelizable" I will create a separate table that monitors the
	*   remainder of the codes.
	****************************************/
	CREATE TABLE [catalog].[PromotionCodes] (
		PromotionId INT PRIMARY KEY IDENTITY
		,Code NVARCHAR(20) NOT NULL CONSTRAINT uc_Code UNIQUE
		,Discount DECIMAL(5, 2) --This represents a dollar amount or percentage (0.20 == 20%)
		,MaxQuantity INT --Total number of times this code can be used
		,MaxQuantityPerUser INT CONSTRAINT df_MaxQuantityPerUser DEFAULT(1)
		,MaxQuantityPerOrder INT CONSTRAINT df_MaxQuantityPerOrder DEFAULT(1)
		,StartDate DATETIME
		,EndDate DATETIME
		,PromotionTypeId INT CONSTRAINT fk_PromotionDiscountType FOREIGN KEY REFERENCES [promotion].DiscountType(DiscountTypeId)
		)
		
	/****************************************
	*	Remaining Quantity: Designates remaining number of times a promotion id can be applied to an order
	****************************************/
	CREATE TABLE [promotion].[RemainingQuantity] (
		PromotionDurationId INT PRIMARY KEY IDENTITY
		,PromotionId INT CONSTRAINT fk_Promotions FOREIGN KEY REFERENCES [catalog].[PromotionCodes](PromotionId)
		,RemainingQuantity INT --MaxQuantity from [catalog].PromotionCodes less the number of times it has been applied
		)

	/****************************************
	*	Promotion Used: Records the use of promotions per user account
	****************************************/
	CREATE TABLE [promotion].[Applied] (
		PromotionAppliedId INT PRIMARY KEY IDENTITY
		,PromotionId INT NOT NULL CONSTRAINT fk_PromotionCodes FOREIGN KEY REFERENCES [catalog].PromotionCodes(PromotionId)
		,UserId INT CONSTRAINT fk_Users FOREIGN KEY REFERENCES [dbo].Users([User_ID])
		,OrderId INT CONSTRAINT fk_Orders FOREIGN KEY REFERENCES [salesorder].[Order](OrderId)
		,ApplyDate DATETIME
		)

	/****************************************
	*	Promotion Products: Maintains reference of promotion to product
	*   NH: keeping this in the catalog schema so that items for promotion can be channelized and maintained by Merch
	****************************************/
	CREATE TABLE [catalog].[PromotionProducts] (
		PromotionItemId INT PRIMARY KEY IDENTITY
		,GersSku NVARCHAR(9) NOT NULL CONSTRAINT fk_Products FOREIGN KEY REFERENCES [catalog].[GersItm](GersSku)
		)

	/****************************************
	*	Promotion Condition: Stores the logic to determine whether discount applies by quantity or price
	****************************************/
	CREATE TABLE [promotion].[Condition] (
		PromotionConditionId INT PRIMARY KEY IDENTITY
		,AccessoryPrice MONEY
		,PhonePrice MONEY
		,TotalPrice MONEY
		,AccessoryQuantity INT
		,PhoneQuantity INT
		,OperatorId INT CONSTRAINT fk_PromotionOperator FOREIGN KEY REFERENCES [promotion].Operator(OperatorId)
		)

	PRINT 'END - Create and populate promotion tables'

SET NOCOUNT OFF

PRINT 'SCRIPT END'