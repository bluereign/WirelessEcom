-- =============================================
-- Author:		Ron Delzer
-- Create date: 3/15/2010
-- Description:	
-- =============================================
CREATE FUNCTION catalog.GetDepositGersSku 
(
	@CarrierId int
)
RETURNS nvarchar(9)
AS
BEGIN
	DECLARE @CarrierName nvarchar(30);
	DECLARE @ReturnGersSku nvarchar(9);
	
	SELECT @CarrierName = CompanyName
	FROM catalog.Company
	WHERE CarrierId = @CarrierId
	
	IF (@CarrierName = 'AT&T')
		SET @ReturnGersSku = N'ATDEPOSIT';

	ELSE IF (@CarrierName = N'T-Mobile')
		SET @ReturnGersSku = N'TMDEPOSIT';

	-- Return the result of the function
	RETURN @ReturnGersSku
END
