
CREATE FUNCTION catalog.ufd_GetCouponDiscount (@CouponCode nvarchar(50))
RETURNS money
AS
BEGIN RETURN (SELECT DiscountValue FROM catalog.coupon WHERE CouponCode = @CouponCode
AND GETDATE() >= ValidStartDate AND CONVERT(date, GETDATE()) <= ValidEndDate)
END