
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetUpgradeCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@RateplanType	nvarchar(3), -- FAM, IND, DAT
	@LineType		nvarchar(3), -- PRI, ADD
	@MonthlyFee		money,
	@DeviceType		nvarchar(20), -- SmartPhone, FeaturePhone, MobileBroadband
	@DeviceSKU		VARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer

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


	IF (@CarrierId='299')
		BEGIN
			SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND DeviceType = @DeviceType
			AND ActivationType LIKE '%U%'
		END

	IF (@CarrierId = '109')
		BEGIN
			IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
	
				SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = 'U' AND IsApple = '1'
				
				ELSE IF (@DeviceType = 'MobileBroadband')
				BEGIN
					IF (@MonthlyFee < 50.00)
					SELECT @GersSku = MAX(CommissionSKU)
					FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
					AND RateplanType = 'EXP' AND Lines = '1'
					ELSE
					SELECT @GersSku = MAX(CommissionSKU)
					FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
					AND RateplanType = 'EXP' AND DeviceType = @DeviceType
				END
			ELSE
				BEGIN
					IF (@RateplanType='FAM' AND @LineType='ADD')
						BEGIN
							IF ((@MonthlyFee+0.01)>=49.99)
							SELECT @GersSku = MAX(CommissionSKU)
							FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'A'
							AND RateplanType = 'EXP' AND @MonthlyFee BETWEEN MinAmount AND MaxAmount
						ELSE SELECT @GersSku = MAX(CommissionSKU)
							FROM catalog.CommissionSKU WHERE CarrierId = '109' AND ActivationType = 'A'
							AND RateplanType = 'EXP' AND @MonthlyFee > MaxAmount
						END
					ELSE IF (@RateplanType='IND' OR (@RateplanType='FAM' AND @LineType='PRI'))
						BEGIN
							IF ((@MonthlyFee+0.01)>=0.01 AND (@MonthlyFee+0.01)<=39.98)
								SELECT @GersSku = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'A'
								AND RateplanType = 'EXP' AND @MonthlyFee BETWEEN MinAmount AND MaxAmount
							ELSE IF ((@MonthlyFee+0.01)>=39.99 AND (@MonthlyFee+0.01)<=59.98)
								SELECT @GersSku = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
								AND MinAmount = '39.99'
							ELSE IF ((@MonthlyFee+0.01)>=59.99) 
								SELECT @GersSku = MAX(CommissionSKU)
								FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
								AND MinAmount = '59.99'
						END
			ELSE
					SELECT @GersSku = MAX(CommissionSKU)
					FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
					AND Lines = '3' AND MinAmount = '0.01'
				END

		END
	IF (@CarrierId='128')
		BEGIN
			SELECT @GersSKu = MAX(CommissionSKU)
			FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND ActivationType = 'U'
			AND RateplanType = @RateplanType
		END
	IF (@CarrierId='42')
		-- ALB does not account for primary or secondary lines
		-- PLAID Plan based on device type and activation type
		BEGIN
				IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
					BEGIN
						SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
						WHERE CarrierId = @CarrierId AND ActivationType = 'U' AND IsApple = '1'
					END
				ELSE 
		
			SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND ActivationType = 'U' AND DeviceType = @DeviceType AND IsApple = '0'
		
		END

	
	RETURN @GersSku;
END

GO
