


-- =============================================
-- Author:		Naomi Hall
-- Create date: 3/18/2013
-- Description:	This is for the Executive Summary weekly dashboard report on SSRS
-- =============================================

CREATE PROCEDURE [logging].[DD_ExecSummaryStatus] 
	-- Add the parameters for the stored procedure here
	@TWStartDate date,
	@TWEndDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--VARIABLES
DECLARE @TWTraffic int
DECLARE @TWBounced int
DECLARE @TWBrowsed int
DECLARE @TWAddtoCart int
DECLARE @TWCommit int
DECLARE @TWBought int
DECLARE @TWBouncerate DECIMAL(9,4)

DECLARE @LWTraffic int
DECLARE @LWBounced int
DECLARE @LWBrowsed int
DECLARE @LWAddtoCart int
DECLARE @LWCommit int
DECLARE @LWBought int
DECLARE @LWBouncerate DECIMAL (9,4)

DECLARE @LWStartDate date
DECLARE @LWEndDate date

SELECT @LWStartDate = DATEADD(day, -7, @TWStartDate)
SELECT @LWEndDate =  DATEADD(day, -7, @TWEndDate)

--Bounced
SELECT @TWBounced = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'BouncesToday'

--Total Traffic
SELECT @TWTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'TrafficToday'

--Total Browsed
SELECT @TWBrowsed = @TWTraffic - @TWBounced

--Total Add to Cart
SELECT @TWAddtoCart= Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'AddtoCartToday'

--Total Commit to Checkout
SELECT @TWCommit = COUNT(DISTINCT SessionId) FROM logging.ReservedStock WHERE CONVERT(date,ReservedTime,101) BETWEEN @TWStartDate AND @TWEndDate

--Total Bought
SELECT @TWBought = COUNT(*) FROM salesorder.[Order] WHERE CONVERT(date,OrderDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Status <> '0'

--Total Bouncerate
SELECT @TWBouncerate = convert(decimal(9,4),@TWBounced)/convert(decimal(9,4),@TWTraffic)





--Bounced
SELECT @LWBounced = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'BouncesToday'

--Total Traffic
SELECT @LWTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'TrafficToday'

--Total Browsed
SELECT @LWBrowsed = @LWTraffic - @LWBounced

--Total Add to Cart
SELECT @LWAddtoCart= Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'AddtoCartToday'

--Total Commit to Checkout
SELECT @LWCommit = COUNT(DISTINCT SessionId) FROM logging.ReservedStock WHERE CONVERT(date,ReservedTime,101) BETWEEN @LWStartDate AND @LWEndDate

--Total Bought
SELECT @LWBought = COUNT(*) FROM salesorder.[Order] WHERE CONVERT(date,OrderDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Status <> '0'

--Total Bouncerate
SELECT @LWBouncerate = convert(decimal(9,4),@LWBounced)/convert(decimal(9,4),@LWTraffic)







DECLARE @Browsed decimal(9,6)
SET @Browsed = CONVERT(DECIMAL(9,4),@TWBrowsed)/CONVERT(DECIMAL(9,4),@TWTraffic)

DECLARE @AddtoCart decimal(9,6)
SET @AddtoCart = CONVERT(DECIMAL(9,4),@TWAddtoCart)/CONVERT(DECIMAL(9,4),@TWTraffic)


DECLARE @CommitCheckout decimal(9,6)
SET @CommitCheckout = CONVERT(DECIMAL(9,4),@TWCommit)/CONVERT(DECIMAL(9,4),@TWTraffic)

SELECT
'4. Status' AS 'Description'
,'' AS 'Traffic'  
, @Browsed AS 'Browsed'
, @AddtoCart AS 'AddtoCart'
, @CommitCheckout AS 'CommitCheckout'
, @TWBought AS 'Bought'
END