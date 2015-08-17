
/****** Object:  UserDefinedFunction [catalog].[GetAddALineCommissionSku]    Script Date: 10/16/2013 14:31:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
ALTER FUNCTION [catalog].[GetAddALineCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@RateplanType	nvarchar(3), --FAM, IND, DAT
	@MonthlyFee		money,
	@DeviceType		nvarchar(20), -- SmartPhone, FeaturePhone, MobileBroadband
	@DeviceSku VARCHAR(9), -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	@LineNumber		int,
	@ProductId		int
)

RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
		DECLARE @Type nvarchar(10)
	DECLARE @RpGersSku nvarchar(9)
	
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;
DECLARE @Manufacturer uniqueidentifier


	SELECT @Manufacturer = d.ManufacturerGuid
		,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
	FROM catalog.Device d
	INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
	WHERE (pp.GersSku = @DeviceSku)	

	IF (@CarrierId = '109')
			IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
				BEGIN
					SELECT @GersSku = CommissionSku FROM catalog.CommissionSKU
					WHERE CarrierId = @CarrierId AND IsApple = '1' AND ActivationType = 'NEW'
				END
		ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
				BEGIN
				SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND @MonthlyFee BETWEEN MinAmount and  MaxAmount
				AND ActivationType = 'NEW' AND Lines > '2' AND RateplanType = 'EXP'
				AND IsApple = '0' AND DeviceType = @DeviceType
				END
				
				
	IF (@CarrierId = '128')
		BEGIN
			SELECT @GersSku = CommissionSKU FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND Lines = '3'
			AND ActivationType = 'New' AND IsApple = '0'
		END
	IF (@CarrierId = '42')
	-- PLAID Plan based on device type and activation type
		BEGIN
			IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
				SELECT @GersSku = MAX(CommissionSku) FROM catalog.commissionsku
				WHERE CarrierId = @CarrierId AND IsApple = '1' AND ActivationType = 'NEW';
			ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60')
				SELECT @GersSku= MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = '42' AND ActivationType = 'NEW' AND IsApple = '0'
				and DeviceType = @DeviceType
		END
		
				
	ELSE IF (@CarrierId = '299')
		BEGIN
			IF (@DeviceType = 'MobileBroadband')
				SELECT @GersSku = 	P.GersSku
									FROM Catalog.Product AS P
									INNER JOIN catalog.Rateplan AS R ON P.ProductGuid = R.RateplanGuid
									WHERE (P.ProductId = @ProductId);
			ELSE IF (@DeviceType <> 'MobileBroadband')
			SELECT @GersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
			WHERE CarrierId = @CarrierId AND Lines >= '2' AND MinAmount = '0'
			AND ActivationType LIKE '%A%' AND IsApple = '0'


			

		END
	
	RETURN @GersSku;
END


















GO


