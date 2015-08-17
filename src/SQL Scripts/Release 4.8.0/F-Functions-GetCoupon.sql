

/****** Object:  UserDefinedFunction [catalog].[ufd_GetCouponDiscount]    Script Date: 06/07/2013 15:24:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[ufd_GetCouponDiscount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [catalog].[ufd_GetCouponDiscount]
GO


/****** Object:  UserDefinedFunction [catalog].[ufd_GetCouponId]    Script Date: 06/07/2013 15:24:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[catalog].[ufd_GetCouponId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [catalog].[ufd_GetCouponId]
GO




CREATE FUNCTION catalog.ufd_GetCouponId (@CouponCode nvarchar(50))
RETURNS int
AS
BEGIN RETURN (SELECT CouponId FROM catalog.coupon WHERE CouponCode = @CouponCode
AND GETDATE() >= ValidStartDate AND CONVERT(date, GETDATE()) <= ValidEndDate)
END
GO

CREATE FUNCTION catalog.ufd_GetCouponDiscount (@CouponCode nvarchar(50))
RETURNS money
AS
BEGIN RETURN (SELECT DiscountValue FROM catalog.coupon WHERE CouponCode = @CouponCode
AND GETDATE() >= ValidStartDate AND CONVERT(date, GETDATE()) <= ValidEndDate)
END
GO



SELECT catalog.ufd_GetCouponId('stellarsave')
SELECT catalog.ufd_GetCouponDiscount('stellarsave')


