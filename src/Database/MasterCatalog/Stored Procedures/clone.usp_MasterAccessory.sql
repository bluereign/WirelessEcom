
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














CREATE PROCEDURE [clone].[usp_MasterAccessory] 
	-- Add the parameters for the stored procedure here
	@ProductId INT -- CAT/OMT should grab this
	,@NewUPC CHAR(12)
	,@NewName NVARCHAR(67)
	,@OldSku NVARCHAR(9) -- CAT/OMT should grab this
	,@OldGuid uniqueidentifier -- CAT/OMT should grab this
	,@GersSku NVARCHAR(9) -- user-defined new SKU
	,@ChannelId INT -- user-defined new ID
	,@Active INT -- user-defined new Active status
AS
BEGIN




--CLONE ACCESSORY INFORMATION

--SELECT cp.* FROM catalog.product cp INNER JOIN catalog.Accessory ca ON cp.ProductGuid = ca.AccessoryGuid WHERE cp.GersSku IS NOT NULL AND cp.Active = '1'

DECLARE @NewProductId int
SELECT @NewProductID = MAX(Seed)+1 FROM catalog.product

/* 1. Enter in new entry to catalog.product table */
INSERT INTO catalog.Product (ProductId, GersSku, Active, ChannelId) VALUES (@NewProductId, @GersSku, @Active, @ChannelId)


DECLARE @NewGuid uniqueidentifier
SELECT @NewGuid = ProductGuid FROM catalog.Product WHERE ProductId = @NewProductId AND GersSku = @GersSku

/* 2. Enter in new entry to catalog.productguid table */
INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId)
VALUES (@NewGuid,'4')

INSERT INTO catalog.ProducttoParentChannel (ParentProductGuid, ProductGuid, ChannelId)
VALUES (@NewGuid, @NewGuid, @ChannelId)

/* 3. Copy in catalog.accessory table  */



DECLARE @TempACC TABLE
	(AccessoryGuid uniqueidentifier NOT NULL
	,ManufacturerGuid uniqueidentifier NULL
	,UPC char(12) NULL
	,Name nvarchar(67) NULL)

INSERT INTO @TempACC (AccessoryGuid, ManufacturerGuid, UPC, Name)
SELECT
	AccessoryGuid, ManufacturerGuid, @NewUPC, @NewName
FROM catalog.Accessory acc WHERE AccessoryGuid = @OldGuid

UPDATE @TempACC SET AccessoryGuid = @NewGuid

INSERT INTO catalog.Accessory (AccessoryGuid, ManufacturerGuid, UPC, Name)
SELECT
	AccessoryGuid, ManufacturerGuid, UPC, Name
FROM @TempACC


/* 4. Copy over descriptions (properties) for Accessories with new AccessoryGuid.  */

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
	,'ClonedAccessory' AS 'LastModifiedBy'
	,Name
	,Value
	,Active
FROM catalog.Property prop WHERE ProductGuid = @OldGuid AND Name <> 'title'

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

/* 8. Copy over images for Devices with new DeviceGuid. */

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

/* 9. Copy over product tags for Accessories. */
DECLARE @TempTag TABLE (ProductGuid uniqueidentifier, Tag nvarchar(100))

INSERT INTO @TempTag (ProductGuid, Tag)
SELECT ProductGuid, Tag FROM catalog.ProductTag WHERE ProductGuid = @OldGuid

UPDATE @TempTag SET ProductGuid = @NewGuid

INSERT INTO catalog.ProductTag
SELECT DISTINCT ProductGuid, Tag FROM @TempTag


END






SELECT @NewGuid AS 'NewProductGuid'






GO
