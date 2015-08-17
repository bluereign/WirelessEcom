





-- =============================================
-- Author:		Naomi Hall
-- Create date: 3/18/2013
-- Description:	This is for the Total Visits weekly dashboard report on SSRS
-- =============================================

CREATE PROCEDURE [logging].[DD_TotalVisits] 
	-- Add the parameters for the stored procedure here
	@TWStartDate date,
	@TWEndDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


DECLARE @TWCostcoTraffic int
DECLARE @TWSearchTraffic int
DECLARE @TWCampaignTraffic int
DECLARE @TWDirectTraffic int
DECLARE @TWTotTraffic int

DECLARE @LWCostcoTraffic int
DECLARE @LWSearchTraffic int
DECLARE @LWCampaignTraffic int
DECLARE @LWDirectTraffic int
DECLARE @LWTotTraffic int

DECLARE @LWStartDate date
DECLARE @LWEndDate date

SELECT @LWStartDate = DATEADD(day, -7, @TWStartDate)
SELECT @LWEndDate =  DATEADD(day, -7, @TWEndDate)

SELECT @TWTotTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'TrafficToday'
SELECT @TWCostcoTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'VisitsCostcoToday'
SELECT @TWSearchTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'VisitsSearchToday'
SELECT @TWCampaignTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @TWStartDate AND @TWEndDate AND Name = 'VisitsCampaignToday'
SELECT @TWDirectTraffic = @TWTotTraffic - SUM(@TWCostcoTraffic+@TWSearchTraffic+@TWCampaignTraffic)


SELECT @LWTotTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'TrafficToday'
SELECT @LWCostcoTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'VisitsCostcoToday'
SELECT @LWSearchTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'VisitsSearchToday'
SELECT @LWCampaignTraffic = Value FROM logging.DashboardData WHERE CONVERT(date,RunDate,101) BETWEEN @LWStartDate AND @LWEndDate AND Name = 'VisitsCampaignToday'
SELECT @LWDirectTraffic = @LWTotTraffic - SUM(@LWCostcoTraffic+@LWSearchTraffic+@LWCampaignTraffic)







SELECT '1. Direct' AS 'Source', @LWDirectTraffic AS 'Last Week', @TWDirectTraffic AS 'This Week', '15%' AS 'Goal', CONVERT(DECIMAL(9,4),@TWDirectTraffic)/CONVERT(DECIMAL(9,4),@TWTotTraffic) AS 'Status'

UNION

SELECT '2. Costco', @LWCostcoTraffic, @TWCostcoTraffic, '65%', CONVERT(DECIMAL(9,4),@TWCostcoTraffic)/CONVERT(DECIMAL(9,4),@TWTotTraffic)

UNION

SELECT '3. Search', @LWSearchTraffic, @TWSearchTraffic, '10%', CONVERT(DECIMAL(9,4),@TWSearchTraffic)/CONVERT(DECIMAL(9,4),@TWTotTraffic)

UNION

SELECT '4. Campaign', @LWCampaignTraffic, @TWCampaignTraffic, '10%', CONVERT(DECIMAL(9,4),@TWCampaignTraffic)/CONVERT(DECIMAL(9,4),@TWTotTraffic)

UNION

SELECT 'Total', @LWTotTraffic, @TWTotTraffic, NULL, NULL

END