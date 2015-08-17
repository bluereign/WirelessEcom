SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [catalog].[GetPrepaidCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@DeviceType		nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;

	IF (@CarrierName = 'Verizon Wireless')
		BEGIN
			SET @GersSku = 'CWSVZMBBP';
		END
	
	
	RETURN @GersSku;
END















GO
