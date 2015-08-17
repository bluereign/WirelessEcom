-- =============================================
-- Author:		Ron Delzer
-- Create date: 10/13/2010
-- Description:	
-- =============================================
CREATE FUNCTION [salesorder].[GetDeliveryDate] 
(
	@IsOvernightShipping bit
)
RETURNS date
AS
BEGIN
	RETURN salesorder.GetDeliveryDateFromOrderDate(GETDATE(), @IsOvernightShipping);
END
