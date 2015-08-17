



-- =============================================
-- Author:		Tyson Vanek
-- Create date: 3/15/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetRateplanMonthlyFee2]
(
	-- Add the parameters for the function here
	@ProductId int,
	@LineNumber int
)
RETURNS money WITH SCHEMABINDING
AS
BEGIN
	DECLARE @PlanType nvarchar(3)
	DECLARE @IncludedLines int
	DECLARE @MaxLines int
	DECLARE @MonthlyFee money
	DECLARE @AdditionalLineFee money
	DECLARE @ReturnFee money
	DECLARE @CarrierGuid varchar(100)
	
	SELECT
		@PlanType = R.Type
	,	@IncludedLines = R.IncludedLines
	,	@MaxLines = R.MaxLines
	,	@MonthlyFee = R.MonthlyFee
	,	@AdditionalLineFee = R.AdditionalLineFee
	,	@CarrierGuid = R.CarrierGuid
	FROM
		catalog.Product AS P
	INNER JOIN
		catalog.Rateplan AS R
			ON P.ProductGuid = R.RateplanGuid
	WHERE
		(P.ProductId = @ProductId);
	
	
	IF @PlanType <> 'FAM'
		BEGIN
			SELECT @ReturnFee = @MonthlyFee;
		END
	ELSE
		BEGIN
			IF @LineNumber = 1 AND @IncludedLines = 1
				BEGIN
					SELECT @ReturnFee = @MonthlyFee + @AdditionalLineFee;
				END
			ELSE IF @LineNumber = 1 AND @IncludedLines = 2
				BEGIN
					SELECT @ReturnFee = @MonthlyFee;
				END
			ELSE IF @LineNumber = 2
				BEGIN
					SELECT @ReturnFee = CAST(0 as money);
				END
			ELSE
				BEGIN
					IF @CarrierGuid = '84C15B47-C976-4403-A7C4-80ABA6EEC189' -- T-Mobile
						BEGIN
							SELECT @ReturnFee = CAST(0 as money);
						END
					ELSE
						BEGIN
							SELECT @ReturnFee = @AdditionalLineFee;
						END
				END
		END

	RETURN @ReturnFee
END