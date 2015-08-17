/****** Object:  UserDefinedFunction [catalog].[GetNoActivationRateplanSku]    Script Date: 03/05/2014 09:29:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [catalog].[GetNoActivationRateplanSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int
	,@DeviceSku NVARCHAR(9) -- the SKU of the device to help identify 3G versus 4G and determine manufacturer
	,@DeviceType		nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;

	
		BEGIN
			SELECT @GersSku = MAX(CommissionSku) FROM catalog.commissionsku
			WHERE CarrierId = @CarrierId AND ActivationType = 'NOACT' AND DeviceType = @DeviceType;
		END
	
	
	RETURN @GersSku;
END


















GO


