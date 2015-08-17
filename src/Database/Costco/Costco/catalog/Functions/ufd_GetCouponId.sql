

CREATE FUNCTION catalog.ufd_GetCouponId (@CouponCode nvarchar(50))
RETURNS int
AS
BEGIN RETURN (SELECT CouponId FROM catalog.coupon WHERE CouponCode = @CouponCode
AND GETDATE() >= ValidStartDate AND CONVERT(date, GETDATE()) <= ValidEndDate)
END