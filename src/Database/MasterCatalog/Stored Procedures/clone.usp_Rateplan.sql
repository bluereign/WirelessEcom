
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [clone].[usp_Rateplan] 
	-- Add the parameters for the stored procedure here
	@ProductId INT -- CAT/OMT should grab this
	,@OldSku NVARCHAR(9) -- CAT/OMT should grab this
	,@OldGuid uniqueidentifier -- CAT/OMT should grab this
	,@GersSku NVARCHAR(9) -- user-defined new SKU
	,@ChannelId INT -- user-defined new ID
	,@Active INT -- user-defined new Active status
AS
BEGIN

/* 1. Enter in new entry to catalog.product table */
INSERT INTO catalog.Product (ProductId, GersSku, Active, ChannelId) VALUES (@ProductId, @GersSku, @Active, @ChannelId)


DECLARE @NewGuid uniqueidentifier
SELECT @NewGuid = ProductGuid FROM catalog.Product WHERE ProductId = @ProductId AND GersSku = @GersSku


/* 2. Enter in new entry to catalog.productguid table */
INSERT INTO catalog.ProductGuid (ProductGuid, ProductTypeId)
VALUES (@NewGuid,'2')

INSERT INTO catalog.ProducttoParentChannel (ParentProductGuid, ProductGuid, ChannelId)
VALUES (@OldGuid, @NewGuid, @ChannelId)

/* 3. Copy in catalog.rateplan table  */
--SELECT * fROM catalog.Rateplan where RateplanGuid = @OldGuid

DECLARE @TempRATE TABLE
	(RateplanGuid uniqueidentifier NOT NULL
	,CarrierGuid uniqueidentifier NOT NULL
	,CarrierBillCode nvarchar(12) NULL
	,Title nvarchar(255) NULL
	,Description nvarchar(255) NULL
	,Type nvarchar(3)
	,ContractTerm int NULL
	,IncludedLines int NULL
	,MaxLines int NULL
	,MonthlyFee money NULL
	,AdditionalLineBillCode nvarchar(12)
	,AdditionalLineFee money NULL
	,PrimaryActivationFee money NULL
	,SecondaryActivationFee money NULL
	,IsShared bit NOT NULL)

INSERT INTO @TempRATE (RateplanGuid, CarrierGuid, CarrierBillCode, Title, DEscription, Type, ContractTerm, IncludedLines,MaxLInes,MonthlyFee,AdditionalLineBillCode,AdditionalLineFee,PrimaryActivationFee,SecondaryActivationFee,IsShared)
SELECT
	RateplanGuid, CarrierGuid, CarrierBillCode, Title, DEscription, Type, ContractTerm, IncludedLines,MaxLInes,MonthlyFee,AdditionalLineBillCode,AdditionalLineFee,PrimaryActivationFee,SecondaryActivationFee,IsShared
FROM catalog.Rateplan RATE WHERE RateplanGuid = @OldGuid

UPDATE @TempRATE SET RateplanGuid = @NewGuid

INSERT INTO catalog.Rateplan (RateplanGuid, CarrierGuid, CarrierBillCode, Title, DEscription, Type, ContractTerm, IncludedLines,MaxLInes,MonthlyFee,AdditionalLineBillCode,AdditionalLineFee,PrimaryActivationFee,SecondaryActivationFee,IsShared)
SELECT
	RateplanGuid, CarrierGuid, CarrierBillCode, Title, DEscription, Type, ContractTerm, IncludedLines,MaxLInes,MonthlyFee,AdditionalLineBillCode,AdditionalLineFee,PrimaryActivationFee,SecondaryActivationFee,IsShared
FROM @TempRATE



/* 4. Copy over RateplanMarket group associations with new RateplanGuid. 

DECLARE @TempRATEMARK TABLE
	(RateplanGuid uniqueidentifier NOT NULL
	,MarketGuid uniqueidentifier NOT NULL
	,CarrierPlanReference nvarchar(15))

INSERT INTO @TempRATEMARK (RateplanGuid, MarketGuid, CarrierPlanReference)
SELECT
	RateplanGuid, MarketGuid, CarrierPlanReference
FROM catalog.RateplanMarket RATEMARK WHERE RateplanGuid = @OldGuid

UPDATE @TempRATEMARK SET RateplanGuid = @NewGuid

INSERT INTO catalog.RateplanMarket(RateplanGuid, MarketGuid, CarrierPlanReference)
SELECT
	RateplanGuid, MarketGuid, CarrierPlanReference
FROM @TempRATEMARK

/* 5. Copy over descriptions (properties) for Rateplans with new RateplanGuid. */

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
	,'ClonedRateplan' AS 'LastModifiedBy'
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

/* 8. Copy over images for Rateplan with new RateplanGuid. */

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


/* 9. Rateplan to Service association. */
DECLARE @RateServ TABLE (
ServiceGuid uniqueidentifier
,RateplanGuid uniqueidentifier
,IsDefault bit
,IsIncluded bit
,IsRequired bit)

INSERT INTO @RateServ (ServiceGuid,RateplanGuid,IsDefault,IsIncluded,IsRequired)
SELECT
	ps.ParentProductGuid AS 'ServiceGuid'
	,@NewGuid
	,crs.IsDefault
	,crs.IsIncluded
	,crs.IsRequired
FROM
	catalog.RateplanService crs
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
WHERE p.ChannelID = '2') ps ON ps.ProductGuid = crs.ServiceGuid
WHERE crs.RateplanGuid = @OldGuid

INSERT INTO catalog.RateplanService (ServiceGuid,RateplanGuid,IsDefault,IsIncluded,IsRequired)
SELECT ServiceGuid,RateplanGuid,IsDefault,IsIncluded,IsRequired FROM @RateServ

*/


END

SELECT @NewGuid AS 'NewGuid'


GO
