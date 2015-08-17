




CREATE FUNCTION [catalog].[GetWirelessLineCarrierPlanId] 
(
	@DeviceType nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
	,@DeviceSku VARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@ProductId int -- the productid from the catalog.product table

)
RETURNS nvarchar(12)
AS
BEGIN



	DECLARE @CarrierId int
	DECLARE @Manufacturer uniqueidentifier
	DECLARE @Type varchar(20)
    DECLARE @BillCode nvarchar(12)
    DECLARE @ReturnCode nvarchar(12)
    
    
    SELECT @BillCode = R.CarrierBillCode
    ,@CarrierId = CC.CarrierId
    FROM catalog.Product AS P INNER JOIN catalog.Rateplan AS R ON P.ProductGuid = R.RateplanGuid
    INNER JOIN catalog.company cc ON cc.companyguid = r.carrierguid
    WHERE (P.ProductId = @ProductId);
	
	SELECT
		@Manufacturer = d.ManufacturerGuid
		,@Type = (SELECT Value FROM catalog.Property WHERE Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND productguid = d.DeviceGuid)
	FROM catalog.Device d
	INNER JOIN catalog.product pp ON pp.productguid = d.DeviceGuid
	WHERE (pp.GersSku = @DeviceSku)	

		IF (@CarrierId <> '299')
		BEGIN
			SELECT @ReturnCode = @BillCode
		END
		ELSE IF (@CarrierId = '299')
		BEGIN
			IF (@BillCode = 'LTD1013')
				SELECT @ReturnCode = @BillCode
			ELSE IF (@BillCode = 'ALLINPDS')
				BEGIN

					IF (@DeviceType = 'FeaturePhone')
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSku WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'FeaturePhone';
					ELSE IF (@DeviceType = 'SmartPhone' AND @Type IN ('LTE','4G'))
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'LTE'
					ELSE IF (@DeviceType = 'SmartPhone' AND @Type IN ('3G'))
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'Wimax'
					ELSE IF (@DeviceType = 'SmartPhone' AND @Manufacturer = '067F1470-D20C-4B29-8738-66F5EA380254')
					SELECT @ReturnCode = CommissionSKU FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND RateplanType = 'IN' AND DeviceType = 'Blackberry'
				END
			ELSE IF (@BillCode NOT IN ('LTD1013','ALLINPDS'))
				BEGIN
				SELECT @ReturnCode = @BillCode
				END
		END
      RETURN @ReturnCode
END