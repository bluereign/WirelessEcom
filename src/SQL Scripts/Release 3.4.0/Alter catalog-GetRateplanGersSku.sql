
/****** Object:  UserDefinedFunction [catalog].[GetRateplanGersSku]    Script Date: 06/18/2012 17:32:18 ******/
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
	-- Add the parameters for the function here
	@ProductId		int,
	@LineNumber		int,
	@DeviceType		nvarchar(20) -- SmartPhone, FeaturePhone, MobileBroadband
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30)
	DECLARE @PlanType nvarchar(3)
	DECLARE @GersSku nvarchar(9)
	DECLARE @IncludedLines int
	DECLARE @MaxLines int
	DECLARE @MonthlyFee money
	DECLARE @AdditionalLineFee money
	DECLARE @ReturnGersSku nvarchar(9)
		
	SELECT
		@CarrierName = C.CompanyName
	,	@PlanType = R.Type
	,	@GersSku = P.GersSku
	,	@IncludedLines = R.IncludedLines
	,	@MaxLines = R.MaxLines
	,	@MonthlyFee = R.MonthlyFee
	,	@AdditionalLineFee = R.AdditionalLineFee
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
	
	IF ( @CarrierName = N'Verizon Wireless' )
		-- Handle Verizon SKUs based on device
		BEGIN
			IF (@DeviceType = 'SmartPhone') SET @ReturnGersSku = 'CWSVZSMRT';
			ELSE IF (@DeviceType = 'FeaturePhone') SET @ReturnGersSku = 'CWSVZFEA';
			ELSE IF (@DeviceType = 'MobileBroadband') SET @ReturnGersSku = 'CWSVZMBN';
		END
	ELSE IF ( @PlanType <> N'FAM' )
		SET @ReturnGersSku = @GersSku;
	ELSE
		BEGIN
			IF ( @LineNumber = 1 )
				SET @ReturnGersSku = @GersSku;
				
			ELSE IF ( @LineNumber > 1 AND @LineNumber <= @IncludedLines )
				BEGIN
					IF ( @CarrierName = N'AT&T' )
						SET @ReturnGersSku = N'FAM2';				
					ELSE IF ( @CarrierName = N'T-Mobile' )
						SET @ReturnGersSku = @GersSku;
					ELSE IF ( @CarrierName = N'Sprint' )
						SET @ReturnGersSku = @GersSku;								
				END
				
			ELSE IF ( @LineNumber > @IncludedLines AND @LineNumber <= @MaxLines)
				BEGIN
					IF ( @CarrierName = N'AT&T' )
						BEGIN
							IF @AdditionalLineFee >= 49.99
								SET @ReturnGersSku = N'CWSATT2AU';
							ELSE
								SET @ReturnGersSku = N'CWSATT2AD';
						END
					ELSE IF ( @CarrierName = N'T-Mobile' )
						SET @ReturnGersSku = N'CWS2YTMAD';
					ELSE IF ( @CarrierName = N'Sprint' )
						SET @ReturnGersSku = 'CWS2YSPAD';
				END
		END
	-- Return the result of the function
	RETURN @ReturnGersSku
END




GO


