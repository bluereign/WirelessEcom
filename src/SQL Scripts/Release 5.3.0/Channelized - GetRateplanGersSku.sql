/****** Object:  UserDefinedFunction [catalog].[GetRateplanGersSku]    Script Date: 10/16/2013 14:30:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/14/2010
-- Description:	
-- =============================================
ALTER FUNCTION [catalog].[GetRateplanGersSku] 
(
    -- Created by Ron Delzer in March 2010
	-- Edited by Naomi in September 2013 for new Sprint plans
	
	
	@CarrierId int -- indicate which carrier it is so we know which special fees to apply
	,@DeviceType nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@DeviceSku VARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
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
	
	SELECT @Manufacturer = d.ManufacturerGuid
		,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
	FROM catalog.Device d
	INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
	WHERE (pp.GersSku = @DeviceSku)	
	
	
		IF (@CarrierId = '299')
		BEGIN
			IF (@BillCode = 'LTD1013')
				SELECT @ReturnGersSku = CommissionSKU
				FROM catalog.CommissionSku
				WHERE CarrierId = @CarrierId AND RateplanType = 'WAY' AND Lines = @CartPlanIdCount;
			ELSE IF (@BillCode = 'ALLINPDS')
				SELECT @ReturnGersSku = GersSKU FROM catalog.product WHERE ProductGuid IN (SELECT RateplanGuid FROM catalog.rateplan WHERE CarrierBillCode = 'ALLINPDS')
			ELSE SET @ReturnGersSku = @GersSku
		END


	IF (@CarrierId = '109')
		BEGIN
		IF (@IsShared = '1')
					SELECT @ReturnGersSku = CommissionSKU FROM catalog.CommissionSKU
					WHERE CarrierId = @CarrierId AND IsApple = '0' AND ActivationType = @ActivationType
					AND DeviceType = @DeviceType AND RateplanType = 'ALL' AND Name = @BillCode;
		
		ELSE IF (@IsShared = '0')
					SELECT @ReturnGersSku = CommissionSKU FROM catalog.CommissionSKU
					WHERE CarrierId = @CarrierId AND IsApple = '0' AND ActivationType = @ActivationType
					AND RateplanType = 'EXP' AND DeviceType = @DeviceType 
					AND @MonthlyFee BETWEEN MinAmount AND MaxAmount AND Lines = @LineNumber;
		ELSE SET @ReturnGersSku = @GersSku
	END
	
	IF (@CarrierId = '42')
		-- Handle Verizon SKUs based on device and activation type
		BEGIN
			IF (@ActivationType <> 'UPGRADE')
				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND IsApple = '0' AND ActivationType = @ActivationType
				AND DeviceType = @DeviceType AND RateplanType = 'ALL';			
			ELSE SET @ReturnGersSku = @GersSku
		END
		
	IF (@CarrierId = '128')
		BEGIN
			IF (@PlanType = 'IND')
			SELECT @ReturnGersSku = CommissionSKU FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType
			ELSE IF (@PlanType = 'FAM')
			SELECT @ReturnGersSku = CommissionSKU FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType AND Lines = @LineNumber			
		END
		
	-- Return the result of the function
	RETURN @ReturnGersSku
END


GO


