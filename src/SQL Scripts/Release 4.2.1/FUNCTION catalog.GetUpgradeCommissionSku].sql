/****** Object:  UserDefinedFunction [catalog].[GetUpgradeCommissionSku]    Script Date: 02/04/2013 13:04:43 ******/
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
			IF (@DeviceType = 'MobileBroadband')
				BEGIN
					IF (@MonthlyFee < 50.00) SET @GersSku='CWSATUPAU';
					ELSE SET @GersSku = 'CWSATUDSM';
				END
			ELSE
				BEGIN
					IF (@RateplanType='FAM' AND @LineType='ADD')
						BEGIN
							IF ((@MonthlyFee+0.01)>=49.99) SET @GersSku='CWSATUPAU';
							ELSE SET @GersSku = 'CWSATUPAD';
						END
					ELSE IF (@RateplanType='IND' OR (@RateplanType='FAM' AND @LineType='PRI'))
						BEGIN
							IF ((@MonthlyFee+0.01)>=0.01 AND (@MonthlyFee+0.01)<=39.98) SET @GersSku='CWSATUPAD';
							ELSE IF ((@MonthlyFee+0.01)>=39.99 AND (@MonthlyFee+0.01)<=59.98) SET @GersSku='CWSATUP39';
							ELSE IF ((@MonthlyFee+0.01)>=59.99) SET @GersSku='CWSATUP59';
						END
				END
		END
	ELSE IF (@CarrierName='T-Mobile')
		BEGIN
			IF (@RateplanType='IND') SET @GersSku='CWSTM2UP';
			ELSE IF (@RateplanType='FAM') SET @GersSku='CWSTM2UPA';
		END
	ELSE IF (@CarrierName='Verizon Wireless')
		-- ALB does not account for primary or secondary lines
		-- PLAID Plan based on device type and activation type
		BEGIN
			IF (@DeviceType = 'SmartPhone') SET @GersSku = 'CWSVZSUG';
			ELSE IF (@DeviceType = 'FeaturePhone') SET @GersSku = 'CWSVZFUG';
			ELSE IF (@DeviceType = 'MobileBroadband') SET @GersSku = 'CWSVZMBU';
		END
	ELSE IF (@CarrierName='Sprint')
		BEGIN
			IF (@DeviceType = 'MobileBroadband') SET @GersSku='CWSSPUPMB';
			ELSE SET @GersSku='CWSSPRTUP';
		END
	
	RETURN @GersSku;
END














GO


