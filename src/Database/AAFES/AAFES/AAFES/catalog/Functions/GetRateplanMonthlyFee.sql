




CREATE FUNCTION [catalog].[GetRateplanMonthlyFee]
(

    -- Created by Tyson Vanek in March 2010
	-- Edited by Naomi in September 2013 for new Sprint plans
	
	@CarrierId int -- indicate which carrier it is so we know which special fees to apply
	,@CartPlanIdCount int -- count the number of times a specific rateplan is in a cart
	,@LineNumber int -- provide the actual line number
	,@ProductId int -- the productid from the catalog.product table
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
	DECLARE @IsShared bit
	DECLARE @BillCode nvarchar(12)
	
	SELECT
		@PlanType = R.Type
		, @BillCode = R.CarrierBillCode
		, @IncludedLines = R.IncludedLines
		, @MaxLines = R.MaxLines
		, @MonthlyFee = R.MonthlyFee
		, @AdditionalLineFee = R.AdditionalLineFee
		, @IsShared = R.IsShared
	FROM catalog.Product AS P
	INNER JOIN catalog.Rateplan AS R ON P.ProductGuid = R.RateplanGuid
	WHERE
		(P.ProductId = @ProductId);
	
	
	      IF @CarrierId = '299' AND @BillCode = 'LTD1013'
            BEGIN
                  SELECT @ReturnFee = MinAmount FROM catalog.CommissionSKU WHERE CarrierId = @CarrierId AND Lines = @CartPlanIdCount AND RateplanType = 'WAY' AND Name like '%monthly fee%'
            END

      ELSE IF @CarrierId = '299' AND @PlanType = 'FAM' AND @IsShared = 1
            BEGIN
                  IF @LineNumber = 1 
                        BEGIN
                              SELECT @ReturnFee = @MonthlyFee
                        END
                  ELSE IF @LineNumber > 1
                        BEGIN
                              SELECT @ReturnFee = CAST(0 as money);
                        END
                  ELSE
                        BEGIN
                              SELECT @ReturnFee = @MonthlyFee;
                        END
            END

           

      ELSE IF @PlanType <> 'FAM' AND @IsShared <> 1
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