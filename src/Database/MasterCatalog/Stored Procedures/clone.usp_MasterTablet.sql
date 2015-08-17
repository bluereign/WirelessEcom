SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE PROCEDURE [clone].[usp_MasterTablet] 
	-- Add the parameters for the stored procedure here
	@ProductId INT -- CAT/OMT should grab this
	,@NewUPC NVARCHAR(20)
	,@NewName NVARCHAR(67)
	,@OldSku NVARCHAR(9) -- CAT/OMT should grab this
	,@OldGuid uniqueidentifier -- CAT/OMT should grab this
	,@GersSku NVARCHAR(9) -- user-defined new SKU
	,@ChannelId INT -- user-defined new ID
	,@Active INT -- user-defined new Active status
AS
BEGIN

/* 1. Enter in new entry to catalog.product table */
DECLARE @NewProductId int
SELECT @NewProductID = MAX(Seed)+1 FROM catalog.product

INSERT INTO catalog.Product (ProductId, GersSku, Active, ChannelId)
VALUES (@NewProductId, @GersSku, @Active, @ChannelId)


DECLARE @NewGuid uniqueidentifier
SELECT @NewGuid = ProductGuid FROM catalog.Product WHERE ProductId = @NewProductId AND GersSku = @GersSku

/* 2. Enter in new entry to catalog.productguid table */
INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId)
VALUES (@NewGuid,'6')

INSERT INTO catalog.ProducttoParentChannel (ParentProductGuid, ProductGuid, ChannelId)
VALUES (@NewGuid, @NewGuid, @ChannelId)

/* 3. Copy in catalog.device table  */

DECLARE @TempDEV TABLE
	(TabletGuid uniqueidentifier NOT NULL
	,CarrierGuid uniqueidentifier NOT NULL
	,ManufacturerGuid uniqueidentifier NULL
	,UPC nvarchar(20) NULL
	,Name nvarchar(67) NULL)

INSERT INTO @TempDEV (TabletGuid, CarrierGuid, ManufacturerGuid, UPC, Name)
SELECT
	TabletGuid
	, CarrierGuid
	, ManufacturerGuid
	, @NewUPC
	, @NewName
FROM catalog.Tablet dev WHERE TabletGuid = @OldGuid

UPDATE @TempDEV SET TabletGuid = @NewGuid

INSERT INTO catalog.Tablet (TabletGuid, CarrierGuid, ManufacturerGuid, UPC, Name)
SELECT
	TabletGuid
	, CarrierGuid
	, ManufacturerGuid
	, UPC
	, Name
FROM @TempDEV

/* 4. Copy over Rateplan to Device associations with new DeviceGuid. */

DECLARE @TempCRD TABLE
	(RateplanGuid uniqueidentifier NOT NULL
	,DeviceGuid uniqueidentifier NOT NULL
	,IsDefaultRateplan bit NOT NULL)

INSERT INTO @TempCRD (RateplanGuid, DeviceGuid, IsDefaultRateplan)
SELECT
	crd.RateplanGuid
	,@NewGuid
	,crd.IsDefaultRateplan
FROM
	catalog.RateplanDevice crd
INNER JOIN (SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '2') ps ON ps.ProductGuid = crd.RateplanGuid
WHERE crd.DeviceGuid = @OldGuid

INSERT INTO catalog.RateplanDevice (DeviceGuid, RateplanGuid, IsDefaultRateplan)
SELECT DeviceGuid, RateplanGuid, IsDefaultRateplan FROM @TempCRD

/* 5. Copy over Service to Device associations with new DeviceGuid. */

DECLARE @TempCDS TABLE
	(DeviceGuid uniqueidentifier NOT NULL
	,ServiceGuid uniqueidentifier NOT NULL
	,IsDefault bit NOT NULL)

INSERT INTO @TempCDS (DeviceGuid, ServiceGuid, IsDefault)
SELECT
	@NewGuid
	,cds.ServiceGuid
	,cds.IsDefault
FROM
	catalog.DeviceService cds
INNER JOIN (SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '2') ps ON ps.ProductGuid = cds.ServiceGuid
WHERE cds.DeviceGuid = @OldGuid

INSERT INTO catalog.DeviceService (DeviceGuid, ServiceGuid, IsDefault)
SELECT DeviceGuid, ServiceGuid, IsDefault FROM @TempCDS

/*6. Copy over tags. */

DECLARE @TempTag TABLE (ProductGuid uniqueidentifier, Tag nvarchar(100))

INSERT INTO @TempTag (ProductGuid, Tag)
SELECT ProductGuid, Tag FROM catalog.ProductTag WHERE ProductGuid = @OldGuid

UPDATE @TempTag SET ProductGuid = @NewGuid

INSERT INTO catalog.ProductTag
SELECT DISTINCT ProductGuid, Tag FROM @TempTag

/* 7. Copy over descriptions (properties) for Devices with new DeviceGuid. */

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
	,'ClonedPhone' AS 'LastModifiedBy'
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


/* 6. Copy over default accessories for Device associations with new DeviceGuid. 

DECLARE @TempCAFD TABLE
	(DeviceGuid uniqueidentifier NOT NULL
	,AccessoryGuid uniqueidentifier NOT NULL
	,Ordinal int NOT NULL)

--INSERT INTO @TempCAFD (DeviceGuid, AccessoryGuid, Ordinal)
SELECT
	DeviceGuid
	,AccessoryGuid
	,Ordinal
FROM catalog.AccessoryforDevice cafd WHERE DeviceGuid = @OldGuid

--UPDATE @TempCAFD SET DeviceGuid = @NewGuid
--UPDATE accessoryguids to match new channel accessory guids

--INSERT INTO catalog.AccessoryforDevice (DeviceGuid, AccessoryGuid, IsDefault)
SELECT
	DeviceGuid
	,AccessoryGuid
	,Ordinal
FROM @TempCAFD

*/

END


SELECT @NewGuid AS 'NewProductGuid'








GO
