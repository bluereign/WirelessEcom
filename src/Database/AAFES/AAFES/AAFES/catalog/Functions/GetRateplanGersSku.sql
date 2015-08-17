









-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/14/2010
-- Description:	
-- =============================================

--SELECT catalog.GetRateplanGersSku('42','Tablet','VIAIR16S','1','1','25463','New')

CREATE FUNCTION [catalog].[GetRateplanGersSku] 
(
    -- Created by Ron Delzer in March 2010
	-- Edited by Naomi in September 2013 for new Sprint plans
	
	
	@CarrierId int -- indicate which carrier it is so we know which special fees to apply
	,@DeviceType nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@DeviceSku NVARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@CartPlanIdCount int -- count the number of times a specific rateplan is in a cart
	,@LineNumber int -- provide the actual line number
	,@ProductId int -- the productid from the catalog.product table
	,@ActivationType varchar(10) -- New, Upgrade, AddALine, Retail
)

RETURNS nvarchar(9)
AS
BEGIN


	DECLARE @Manufacturer uniqueidentifier
	DECLARE @CarrierName nvarchar(30)
	DECLARE @PlanType nvarchar(3)
	DECLARE @GersSku nvarchar(9)
	DECLARE @IncludedLines int
	DECLARE @MaxLines int
	DECLARE @MonthlyFee money
	DECLARE @AdditionalLineFee money
	DECLARE @ReturnGersSku nvarchar(9)
	DECLARE @BillCode nvarchar(12)
	DECLARE @Type nvarchar(10)
	DECLARE @IsShared bit
		
	SELECT
		@CarrierName = C.CompanyName
	,	@BillCode = R.CarrierBillCode
	,	@PlanType = R.Type
	,	@GersSku = P.GersSku
	,	@IncludedLines = R.IncludedLines
	,	@MaxLines = R.MaxLines
	,	@MonthlyFee = R.MonthlyFee
	,	@AdditionalLineFee = R.AdditionalLineFee
	,	@IsShared = R.IsShared
	FROM
		catalog.Product AS P
	INNER JOIN
		catalog.Rateplan AS R
			ON P.ProductGuid = R.RateplanGuid
	INNER JOIN
        catalog.Company AS C
			ON R.CarrierGuid = C.CompanyGuid
	WHERE
		(P.ProductId = @ProductId);

BEGIN
	IF @DeviceType = 'Tablet'
		SELECT @Manufacturer = d.ManufacturerGuid
		FROM catalog.tablet d
		INNER JOIN catalog.product pp ON pp.productguid = d.TabletGuid
		WHERE pp.GersSku = @DeviceSku
	ELSE IF @DeviceType <> 'Tablet'
		SELECT @Manufacturer = d.ManufacturerGuid
		FROM catalog.device d
		INNER JOIN catalog.product pp ON pp.productguid = d.deviceGuid
		WHERE pp.GersSku = @DeviceSku
END
	
		IF (@CarrierId = '299' AND @Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		BEGIN
			IF (@BillCode = 'LTD1013')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSku
				WHERE CarrierId = @CarrierId AND RateplanType = 'WAY' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '0' AND @DeviceType = DeviceType;
			ELSE IF (@BillCode = 'ALLINPDS')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '0' AND @DeviceType = DeviceType;
			ELSE IF (@BillCode LIKE 'PDSL01%')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'DAT' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '0' AND @DeviceType = DeviceType;


			ELSE IF (@BillCode LIKE 'LSD%')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'LSD' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '0' AND @DeviceType = DeviceType;
			ELSE SET @ReturnGersSku = @GersSku
			
		END

		IF (@CarrierId = '299' AND @Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		BEGIN
			IF (@BillCode = 'LTD1013')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSku
				WHERE CarrierId = @CarrierId AND RateplanType = 'WAY' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '1' AND @DeviceType = DeviceType;
			ELSE IF (@BillCode = 'ALLINPDS')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '1' AND @DeviceType = DeviceType;
			ELSE IF (@BillCode = 'PDSA0019')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'SU' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '1' AND @DeviceType = DeviceType;
			ELSE IF (@BillCode LIKE 'PDSL01%')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'DAT' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '1' AND @DeviceType = DeviceType;

			ELSE IF (@BillCode LIKE 'LSD%')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND RateplanType = 'LSD' AND Lines = @CartPlanIdCount
				AND ActivationType = @ActivationType AND IsApple = '1' AND @DeviceType = DeviceType;
			ELSE SELECT @ReturnGersSku = @GersSku
		END


	IF (@CarrierId = '109')
		-- Handle AT&T SKUs based on device and activation type
		BEGIN
			IF  (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		
				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType AND IsApple = '1'
				AND DeviceType = @DeviceType;

		ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		
				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND IsApple = '0' AND ActivationType = @ActivationType
				AND DeviceType = @DeviceType;			
		
		ELSE SET @ReturnGersSku = @GersSku
		
		END
	
	
	IF (@CarrierId = '42')
		-- Handle Verizon SKUs based on device and activation type
		BEGIN
			IF  (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		
				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType AND IsApple = '1'
				AND DeviceType = @DeviceType;

		ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		
				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND IsApple = '0' AND ActivationType = @ActivationType
				AND DeviceType = @DeviceType;			
		
		ELSE SET @ReturnGersSku = @GersSku
		
		END
		
	RETURN @ReturnGersSku
END