
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














CREATE PROCEDURE [clone].[usp_Service] 
	-- Add the parameters for the stored procedure here
	@ProductId INT -- CAT/OMT should grab this
	,@OldSku NVARCHAR(9) -- CAT/OMT should grab this
	,@OldGuid uniqueidentifier -- CAT/OMT should grab this
	,@GersSku NVARCHAR(9) -- user-defined new SKU
	,@ChannelId INT -- user-defined new ID
	,@Active INT -- user-defined new Active status
AS
BEGIN

--CLONE SERVICE INFORMATION

--SELECT * FROM catalog.service cs INNER JOIN catalog.Product cp ON cp.ProductGuid = cs.ServiceGuid WHERE GersSku IS NOT NULL

--grab the following information in order to clone

/* 1. Enter in new entry to catalog.product table */
DECLARE @NewGuid uniqueidentifier
SELECT @NewGuid = NEWID()

INSERT INTO catalog.Product (ProductId, ProductGuid, GersSku, Active, ChannelId)
SELECT @ProductId, @NewGuid, @GersSku, @Active, @ChannelId



/* 2. Enter in new entry to catalog.productguid table */
INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId)
VALUES (@NewGuid,'3')

INSERT INTO catalog.ProducttoParentChannel (ParentProductGuid, ProductGuid, ChannelId)
VALUES (@OldGuid, @NewGuid, @ChannelId)

/* 3. Copy in catalog.service table  */


DECLARE @TempSERV TABLE
	(ServiceGuid uniqueidentifier NOT NULL
	,CarrierGuid uniqueidentifier NOT NULL
	,CarrierServiceId nvarchar(12) NULL
	,CarrierBillCode nvarchar(12) NULL
	,Title nvarchar(100) NULL
	,MonthlyFee money NULL
	,CartTypeId nvarchar(50) NULL)

INSERT INTO @TempSERV (ServiceGuid, CarrierGuid, CarrierServiceId, CarrierBillCode, Title, MonthlyFee, CartTypeId)
SELECT
	ServiceGuid, CarrierGuid, CarrierServiceId, CarrierBillCode, Title, MonthlyFee, CartTypeId
FROM catalog.Service serv WHERE ServiceGuid = @OldGuid

UPDATE @TempSERV SET ServiceGuid = @NewGuid

INSERT INTO catalog.Service (ServiceGuid, CarrierGuid, CarrierServiceId, CarrierBillCode, Title, MonthlyFee, CartTypeId)
SELECT
	ServiceGuid, CarrierGuid, CarrierServiceId, CarrierBillCode, Title, MonthlyFee, CartTypeId
FROM @TempSERV

/* 4. Copy over ServiceMaster group associations with new ServiceGuid.

DECLARE @TempSERVMAS TABLE
	(ServiceMasterGroupGuid uniqueidentifier NOT NULL
	,Label varchar(150) NULL
	,ServiceGuid uniqueidentifier NULL
	,Ordinal int NULL)

INSERT INTO @TempSERVMAS (ServiceMasterGroupGuid, Label, ServiceGuid, Ordinal)
SELECT
	ServiceMasterGroupGuid, Label, ServiceGuid, Ordinal
FROM catalog.ServiceMaster servmas WHERE ServiceGUID = @OldGuid

UPDATE @TempSERVMAS SET ServiceGuid = @NewGuid

INSERT INTO catalog.ServiceMaster (ServiceMasterGroupGuid, Label, ServiceGuid, Ordinal)
SELECT
	ServiceMasterGroupGuid, Label, ServiceGuid, Ordinal
FROM @TempSERVMAS

/* 5. Copy over descriptions (properties) for Services with new ServiceGuid. */

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
	,'ClonedService' AS 'LastModifiedBy'
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

/* 8. Copy over images for Services with new ServiceGuid. */

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
 */

END


SELECT @NewGuid AS 'NewGuid'










GO
