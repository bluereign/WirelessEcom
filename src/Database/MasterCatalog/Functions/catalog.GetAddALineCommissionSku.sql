SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/12/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetAddALineCommissionSku] 
(
	-- Add the parameters for the function here
	@CarrierId		int,
	@RateplanType	nvarchar(3), --FAM, IND, DAT
	@MonthlyFee		money,
	@DeviceType		nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @GersSku nvarchar(9)
	
	SELECT @CarrierName=CompanyName FROM catalog.Company WHERE CarrierId=@CarrierId;

	IF (@CarrierName = 'AT&T')
		BEGIN
			IF (@MonthlyFee < 49.99) SET @GersSku='CWSATT2AD'; -- Currently on limited minute plan
			ELSE SET @GersSku='CWSATT2AU'; -- Currently on unlimited plan
		END
	ELSE IF (@CarrierName = 'T-Mobile')
		BEGIN
			SET @GersSku = 'CWS2YTMAD';
		END
	ELSE IF (@CarrierName = 'Verizon Wireless')
		-- PLAID Plan based on device type and activation type
		BEGIN
			IF (@DeviceType = 'SmartPhone') SET @GersSku = 'CWSVZSMRT';
			ELSE IF (@DeviceType = 'FeaturePhone') SET @GersSku = 'CWSVZFEA';
			ELSE IF (@DeviceType = 'MobileBroadband') SET @GersSku = 'CWSVZMBN';
		END
	ELSE IF (@CarrierName = 'Sprint')
		BEGIN
			SET @GersSku = 'CWS2YSPAD';
		END
	
	
	RETURN @GersSku;
END














GO
