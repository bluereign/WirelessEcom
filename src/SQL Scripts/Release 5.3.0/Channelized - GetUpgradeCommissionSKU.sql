/****** Object:  UserDefinedFunction [catalog].[GetUpgradeCommissionSku]    Script Date: 10/16/2013 14:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
ALTER FUNCTION [catalog].[GetUpgradeCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@RateplanType	nvarchar(3), -- FAM, IND, DAT
	@LineType		nvarchar(3), -- PRI, ADD
	@MonthlyFee		money,
	@DeviceType		nvarchar(20), -- SmartPhone, FeaturePhone, MobileBroadband
	@DeviceSKU		VARCHAR(9), -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	@LineNumber		int,
	@ProductId		int

)

RETURNS nvarchar(9)



AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
	DECLARE @Manufacturer uniqueidentifier
	DECLARE @Type nvarchar(10)
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;
	
	
	      SELECT @Manufacturer = d.ManufacturerGuid
            ,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
      FROM catalog.Device d
      INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
      WHERE (pp.GersSku = @DeviceSku)     

/*
IF (@CarrierId='299')
		BEGIN
			IF (@DeviceType = 'MobileBroadband') SET @GersSku='CWSSPUPMB';
			ELSE SET @GersSku='CWSSPRTUP';
		END
*/

	IF (@CarrierId='299')
		BEGIN
			IF (@DeviceType = 'MobileBroadband')
			SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND DeviceType = 'MobileBroadband'
			AND ActivationType = 'U'
			ELSE
			SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND DeviceType = 'Smartphone'
			AND ActivationType = 'U'
		END
		
		

	IF (@CarrierId = '109')
		BEGIN
			IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
	
				SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE' AND IsApple = '1'
				
				ELSE IF (@DeviceType = 'MobileBroadband')
				BEGIN
					IF (@MonthlyFee < 50.00)
					SELECT @GersSku = MAX(CommissionSKU)
					FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
					AND RateplanType = 'EXP' AND Lines = '1'
					ELSE
					SELECT @GersSku = MAX(CommissionSKU)
					FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
					AND RateplanType = 'EXP' AND DeviceType = @DeviceType
				END
			ELSE
				BEGIN
					IF (@RateplanType='FAM' AND @LineNumber > '1')
						BEGIN
						IF ((@MonthlyFee+0.01)>=49.99)
							SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
							WHERE RateplanType = 'EXP' AND ActivationType = 'UPGRADE'
							AND MinAmount >= '49.99' AND Lines = '3'
						ELSE SELECT @GersSku = MAX(CommissionSKU)
							FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
							AND Lines = '3' AND MinAmount = '0.01';
						END
					ELSE IF (@RateplanType='IND' OR (@RateplanType='FAM' AND @LineNumber = '1'))
						BEGIN
							IF ((@MonthlyFee+0.01)>=0.01 AND (@MonthlyFee+0.01)<=39.98)
								SELECT @GersSku = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
								AND Lines = '3' AND MinAmount = '0.01';
							
							ELSE IF ((@MonthlyFee+0.01)>=39.99 AND (@MonthlyFee+0.01)<=59.98)
								SELECT @GersSKu = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
								AND MinAmount = '39.99' AND MaxAmount = '59.98';
							
							ELSE IF ((@MonthlyFee+0.01)>=59.99) 
														
								SELECT @GersSKu = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
								AND MinAmount = '59.99';
						END
			ELSE SELECT @GersSku = MAX(CommissionSKU)
						FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
						AND Lines = '3' AND MinAmount = '0.01';
				END
			END

						
		
	IF (@CarrierId='128')
		BEGIN
			SELECT @GersSKu = MAX(CommissionSKU)
			FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
			AND RateplanType = @RateplanType
		END
		
	IF (@CarrierId='42')
		BEGIN
			IF  (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
		-- ALB does not account for primary or secondary lines
		-- PLAID Plan based on device type and activation type
				SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE' AND IsApple = '1'
			
			ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
			
				SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
				AND DeviceType = @DeviceType AND IsApple = '0'
		
			ELSE IF (@GersSku IS NULL)
		
				SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = 'UPGRADE'
				AND DeviceType = 'Smartphone' AND IsApple = '0'		
		
		END
	
	RETURN @GersSku;
END




GO


