





--SELECT [catalog].[GetKeepRateplanSku] ('299','SGS4TBWHT','SmartPhone','Addaline','1')

CREATE FUNCTION [catalog].[GetKeepRateplanSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int
	,@DeviceSku NVARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@DeviceType		nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@ActivationType varchar(10) -- New, Upgrade, AddALine, Retail
	,@LineNumber int -- line number for Sprint
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @ReturnGersSku nvarchar(9)
	DECLARE @Manufacturer uniqueidentifier
	
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
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;

	
	BEGIN
		IF  (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60' AND @CarrierId <> '299')

				SELECT @ReturnGersSku = MAX(CommissionSKU) FROM catalog.CommissionSKU
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType AND RateplanType = 'UNK' AND IsApple = '1'
				AND DeviceType = @DeviceType;

		
		ELSE IF (@Manufacturer = '47A9293D-ED40-444A-BA35-C18C3A4EFC60' AND @CarrierId =  '299')
		
				SELECT @ReturnGersSku = MAX(CommissionSku) FROM catalog.commissionsku
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType
				AND RateplanType = 'UNK' AND DeviceType = @DeviceType AND Lines = @LineNumber
				AND IsApple = '1';

		
		
		ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60' AND @CarrierId =  '299')
		
				SELECT @ReturnGersSku = MAX(CommissionSku) FROM catalog.commissionsku
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType
				AND RateplanType = 'UNK' AND DeviceType = @DeviceType AND Lines = @LineNumber
				AND IsApple = '0';


		ELSE IF (@Manufacturer <> '47A9293D-ED40-444A-BA35-C18C3A4EFC60' AND @CarrierId <> '299')

				SELECT @ReturnGersSku = MAX(CommissionSku) FROM catalog.commissionsku
				WHERE CarrierId = @CarrierId AND ActivationType = @ActivationType
				AND RateplanType = 'UNK' AND DeviceType = @DeviceType
				AND IsApple = '0';
		
		END
	
	
	
	RETURN @ReturnGersSku;
END