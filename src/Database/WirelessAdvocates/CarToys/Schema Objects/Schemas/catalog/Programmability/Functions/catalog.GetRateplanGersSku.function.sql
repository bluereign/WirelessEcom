

-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/14/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetRateplanGersSku] 
(
	-- Add the parameters for the function here
	@ProductId int,
	@LineNumber int
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
	
	IF ( @PlanType <> N'FAM' )
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
					ELSE IF ( @CarrierName = N'Verizon Wireless' )
						BEGIN
							IF @AdditionalLineFee >= 49.99
								SET @ReturnGersSku = N'CWS2VZADU';
							ELSE
								SET @ReturnGersSku = N'CWS2VZADD';
						END
					ELSE IF ( @CarrierName = N'T-Mobile' )
						SET @ReturnGersSku = N'CWS2YTMAD';
				END
		END
	-- Return the result of the function
	RETURN @ReturnGersSku
END


