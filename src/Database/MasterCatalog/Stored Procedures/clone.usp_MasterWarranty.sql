
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [clone].[usp_MasterWarranty] 
	-- Add the parameters for the stored procedure here
	@ProductId INT -- CAT/OMT should grab this
	,@OldSku NVARCHAR(9) -- CAT/OMT should grab this
	,@OldGuid uniqueidentifier -- CAT/OMT should grab this
	,@GersSku NVARCHAR(9) -- user-defined new SKU
	,@ChannelId INT -- user-defined new ID
	,@Active INT -- user-defined new Active status
AS
BEGIN


--CLONE WARRANTY INFORMATION

--SELECT * FROM catalog.Product cp INNER JOIN catalog.warranty cw on cw.WarrantyGuid = cp.ProductGuid

--grab the following information in order to clone

--have user enter the following information


/* 1. Enter in new entry to catalog.product table */
DECLARE @NewProductId int
SELECT @NewProductID = MAX(Seed)+1 FROM catalog.product

INSERT INTO catalog.Product (ProductId, GersSku, Active, ChannelId) VALUES (@NewProductId, @GersSku, @Active, @ChannelId)
--SELECT @NewProductId, G FROM catalog.Product WHERE ProductId = @ProductId

DECLARE @NewGuid uniqueidentifier
SELECT @NewGuid = ProductGuid FROM catalog.Product WHERE ProductId = @ProductId AND GersSku = @GersSku

/* 2. Enter in new entry to catalog.productguid table */
INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId)
VALUES (@NewGuid,'5')

INSERT INTO catalog.ProducttoParentChannel (ParentProductGuid, ProductGuid, ChannelId)
VALUES (@NewGuid, @OldGuid, @ChannelId)


/* 3. Copy in catalog.warranty table  */

--SELECT * FROM catalog.warranty

DECLARE @TempWARR TABLE
	(WarrantyGuid uniqueidentifier NOT NULL
	,CarrierId nvarchar(50) NOT NULL
	,UPC nvarchar(20) NULL
	,Title nvarchar(100) NULL
	,Description nvarchar(255) NULL
	,ContractTerm int NULL
	,Price money NULL
	,Deductible money NULL
	,MonthlyFee money NULL
	,AdditionalDevicePrice money NULL
	,AdditionalDeviceDeductible money NULL
	,AdditionalDeviceMonthlyFee money NULL)

INSERT INTO @TempWARR (WarrantyGuid, CarrierId, UPC, Title, Description, ContractTerm, Price, Deductible, MonthlyFee, AdditionalDevicePrice, AdditionalDeviceDeductible, AdditionalDeviceMonthlyFee)
SELECT
	WarrantyGuid, CarrierId, UPC, Title, Description, ContractTerm, Price, Deductible, MonthlyFee, AdditionalDevicePrice, AdditionalDeviceDeductible, AdditionalDeviceMonthlyFee
FROM catalog.warranty warr WHERE WarrantyGuid = @OldGuid

UPDATE @TempWARR SET WarrantyGuid = @NewGuid

INSERT INTO catalog.Warranty (WarrantyGuid, CarrierId, UPC, Title, Description, ContractTerm, Price, Deductible, MonthlyFee, AdditionalDevicePrice, AdditionalDeviceDeductible, AdditionalDeviceMonthlyFee)
SELECT
	WarrantyGuid, CarrierId, UPC, Title, Description, ContractTerm, Price, Deductible, MonthlyFee, AdditionalDevicePrice, AdditionalDeviceDeductible, AdditionalDeviceMonthlyFee
FROM @TempWARR


/* 4. Copy over descriptions (properties) for Warranty with new WarrantyGuid. */

DECLARE @TempPROP TABLE
	(ProductGuid uniqueidentifier NOT NULL
	,IsCustom bit NULL
	,LastModifiedDate datetime NOT NULL
	,LastModifiedBy nvarchar(50) NOT NULL
	,Name nvarchar(50) NULL
	,Value nvarchar(max) NULL
	,Active bit NOT NULL)

INSERT INTO @TempPROP (ProductGuid, IsCustom, LastModifiedDate, LastModifiedBy, Name, Value, Active)
SELECT
	ProductGuid
	,IsCustom
	,GETDATE() AS 'LastModifiedDate'
	,'ClonedWarranty' AS 'LastModifiedBy'
	,Name
	,Value
	,Active
FROM catalog.Property prop WHERE ProductGuid = @OldGuid

UPDATE @TempPROP SET ProductGuid = @NewGuid

INSERT INTO catalog.Property (ProductGuid, IsCustom, LastModifiedDate, LastModifiedBy, Name, Value, Active)
SELECT
	ProductGuid
	,IsCustom
	,LastModifiedDate
	,LastModifiedBy
	,Name
	,Value
	,Active
FROM @TempPROP

/* 8. Copy over images for new guid. */

DECLARE @TempIMAGE TABLE
	(ReferenceGuid uniqueidentifier NOT NULL
	,IsActive bit NULL
	,IsPrimaryImage bit NULL
	,Title varchar(250) NULL
	,Caption varchar(1000) NULL
	,Alt varchar(250) NULL
	,OriginalHeight int NULL
	,OriginalWidth int NULL
	,CreatedDate datetime NULL
	,CreatedBy varchar(50) NULL
	,Ordinal int NULL
	,binImage image NULL)

INSERT INTO @TempIMAGE (ReferenceGuid, IsActive, IsPrimaryImage, Title, Caption, Alt, OriginalHeight, OriginalWidth, CreatedDate, CreatedBy, Ordinal, binImage)
SELECT
	ReferenceGuid
	, IsActive
	, IsPrimaryImage
	, Title
	, Caption
	, Alt
	, OriginalHeight
	, OriginalWidth
	, GETDATE() AS 'CreatedDate'
	, 'Cloned Phone' AS CreatedBy
	, Ordinal
	, binImage
FROM catalog.Image image WHERE ReferenceGuid = @OldGuid

UPDATE @TempIMAGE SET ReferenceGuid = @NewGuid

INSERT INTO catalog.Image (ReferenceGuid, IsActive, IsPrimaryImage, Title, Caption, Alt, OriginalHeight, OriginalWidth, CreatedDate, CreatedBy, Ordinal, binImage)
SELECT
	ReferenceGuid
	, IsActive
	, IsPrimaryImage
	, Title
	, Caption
	, Alt
	, OriginalHeight
	, OriginalWidth
	, CreatedDate
	, CreatedBy
	, Ordinal
	, binImage
FROM @TempIMAGE

END



GO
