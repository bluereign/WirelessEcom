

-- =============================================
-- Author:		Tyson Vanek
-- Create date: 3/15/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetRateplanMonthlyFee]
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
	
	SELECT
		@PlanType = R.Type
	,	@IncludedLines = R.IncludedLines
	,	@MaxLines = R.MaxLines
	,	@MonthlyFee = R.MonthlyFee
	,	@AdditionalLineFee = R.AdditionalLineFee
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
					SELECT @ReturnFee = @AdditionalLineFee;
				END
		END

	RETURN @ReturnFee
END


