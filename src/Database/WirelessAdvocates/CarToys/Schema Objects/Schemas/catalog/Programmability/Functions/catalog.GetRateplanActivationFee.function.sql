






-- =============================================
-- Author:		Tyson Vanek
-- Create date: 3/15/2010
-- Description:	
-- =============================================
CREATE FUNCTION [catalog].[GetRateplanActivationFee]
(
	-- Add the parameters for the function here
	@ProductId int,
	@LineNumber int,
	@CarrierId int = 0
)
RETURNS money WITH SCHEMABINDING
AS
BEGIN
	DECLARE @PlanType nvarchar(3)
	DECLARE @PrimaryActivationFee money
	DECLARE @SecondaryActivationFee money
	DECLARE @ReturnFee money
	
	SELECT
		@PlanType = R.Type
	,	@PrimaryActivationFee = ISNULL(R.PrimaryActivationFee,CAST(0 as money))
	,	@SecondaryActivationFee = ISNULL(R.SecondaryActivationFee,CAST(0 as money))
	FROM
		catalog.Product AS P
	INNER JOIN
		catalog.Rateplan AS R
			ON P.ProductGuid = R.RateplanGuid
	WHERE
		(P.ProductId = @ProductId);
	
	IF @PlanType <> 'FAM'
		BEGIN
			SELECT @ReturnFee = ISNULL(@PrimaryActivationFee,CAST(0 as money));
		END
	ELSE
		BEGIN
			IF @LineNumber = 1
				BEGIN
					SELECT @ReturnFee = ISNULL(@PrimaryActivationFee,CAST(0 as money));
				END
			ELSE
				-- Primary Activation Fee applies to first two lines for Sprint
				IF (@CarrierId = 299 AND @LineNumber = 2) 
					BEGIN
						SELECT @ReturnFee = ISNULL(@PrimaryActivationFee,CAST(0 as money));
					END
				ELSE
					BEGIN
						SELECT @ReturnFee = ISNULL(@SecondaryActivationFee,CAST(0 as money));
					END
		END

	RETURN @ReturnFee
END







