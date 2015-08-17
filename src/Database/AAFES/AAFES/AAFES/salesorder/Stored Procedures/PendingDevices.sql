


CREATE proc [salesorder].[PendingDevices]
	@StartDate date
	,@EndDate date
as

begin

	DECLARE @ATT TABLE (OrderDate date,Carrier int);
DECLARE @Verizon TABLE (OrderDate date,Carrier int);
DECLARE @Sprint TABLE (OrderDate date,Carrier int);
DECLARE @Boost TABLE (OrderDate date,Carrier int);

WITH durp (PendingDate,OrderDate,OrderId,ActivationType,CarrierId) AS (
SELECT DISTINCT CONVERT(VARCHAR(10),ChangeDate,101) AS 'PendingDate', OrderDate,OrderId, ActivationType, CarrierId FROM logging.orders 
WHERE Status IN ('1','2') AND GERSStatus = '0' AND ActivationType NOT IN ('E')
AND OrderId NOT IN (SELECT DISTINCT OrderId FROM logging.orders WHERE Status IN ('3','4'))
AND CONVERT(date,ChangeDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
)

INSERT INTO @ATT
SELECT DISTINCT
	 CONVERT(varchar(10),so.OrderDate,101) AS 'OrderDate'
--	 ,DATEDIFF(DAY, CONVERT(varchar(10),so.OrderDate,101), @EndDate) AS 'DaysPending'
      ,COUNT(sod.OrderDetailId) AS 'ATT'
FROM durp so
INNER JOIN catalog.Company cc ON cc.CarrierId = so.CarrierId
INNER JOIN salesorder.orderdetail sod ON sod.OrderId = so.OrderId AND sod.OrderDetailType = 'd'
INNER JOIN salesorder.[Order] sso ON sso.OrderId = so.OrderId
INNER JOIN salesorder.address sa ON sa.addressguid = sso.shipaddressguid
WHERE CONVERT(date,so.PendingDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
AND cc.CompanyName = 'AT&T'
AND so.ActivationType IN ('N','A','P','R','A','U','E')
GROUP BY  cc.CompanyName, CONVERT(varchar(10),so.OrderDate,101);

WITH durp (PendingDate,OrderDate,OrderId,ActivationType,CarrierId) AS (
SELECT DISTINCT CONVERT(VARCHAR(10),ChangeDate,101) AS 'PendingDate', OrderDate,OrderId, ActivationType, CarrierId FROM logging.orders 
WHERE Status IN ('1','2') AND GERSStatus = '0' AND ActivationType NOT IN ('E')
AND OrderId NOT IN (SELECT DISTINCT OrderId FROM logging.orders WHERE Status IN ('3','4'))
AND CONVERT(date,ChangeDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
)

INSERT INTO @SPRINT
SELECT DISTINCT
	 CONVERT(varchar(10),so.OrderDate,101) AS 'OrderDate'
--	 ,DATEDIFF(DAY, CONVERT(varchar(10),so.OrderDate,101), @EndDate) AS 'DaysPending'
      ,COUNT(sod.OrderDetailId) AS 'ATT'
FROM durp so
INNER JOIN catalog.Company cc ON cc.CarrierId = so.CarrierId
INNER JOIN salesorder.orderdetail sod ON sod.OrderId = so.OrderId AND sod.OrderDetailType = 'd'
INNER JOIN salesorder.[Order] sso ON sso.OrderId = so.OrderId
INNER JOIN salesorder.address sa ON sa.addressguid = sso.shipaddressguid
WHERE CONVERT(date,so.PendingDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
AND cc.CompanyName = 'Sprint'
AND so.ActivationType IN ('N','A','P','R','A','U','E')
GROUP BY  cc.CompanyName, CONVERT(varchar(10),so.OrderDate,101);

WITH durp (PendingDate,OrderDate,OrderId,ActivationType,CarrierId) AS (
SELECT DISTINCT CONVERT(VARCHAR(10),ChangeDate,101) AS 'PendingDate', OrderDate,OrderId, ActivationType, CarrierId FROM logging.orders 
WHERE Status IN ('1','2') AND GERSStatus = '0' AND ActivationType NOT IN ('E')
AND OrderId NOT IN (SELECT DISTINCT OrderId FROM logging.orders WHERE Status IN ('3','4'))
AND CONVERT(date,ChangeDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
)

INSERT INTO @VERIZON
SELECT DISTINCT
	 CONVERT(varchar(10),so.OrderDate,101) AS 'OrderDate'
--	 ,DATEDIFF(DAY, CONVERT(varchar(10),so.OrderDate,101), @EndDate) AS 'DaysPending'
      ,COUNT(sod.OrderDetailId) AS 'Verizon'
FROM durp so
INNER JOIN catalog.Company cc ON cc.CarrierId = so.CarrierId
INNER JOIN salesorder.orderdetail sod ON sod.OrderId = so.OrderId AND sod.OrderDetailType = 'd'
INNER JOIN salesorder.[Order] sso ON sso.OrderId = so.OrderId
INNER JOIN salesorder.address sa ON sa.addressguid = sso.shipaddressguid
WHERE CONVERT(date,so.PendingDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
AND cc.CompanyName = 'Verizon Wireless'
AND so.ActivationType IN ('N','A','P','R','A','U','E')
GROUP BY  cc.CompanyName, CONVERT(varchar(10),so.OrderDate,101);


WITH durp (PendingDate,OrderDate,OrderId,ActivationType,CarrierId) AS (
SELECT DISTINCT CONVERT(VARCHAR(10),ChangeDate,101) AS 'PendingDate', OrderDate,OrderId, ActivationType, CarrierId FROM logging.orders 
WHERE Status IN ('1','2') AND GERSStatus = '0' AND ActivationType NOT IN ('E')
AND OrderId NOT IN (SELECT DISTINCT OrderId FROM logging.orders WHERE Status IN ('3','4'))
)

INSERT INTO @Boost
SELECT DISTINCT
	 CONVERT(varchar(10),so.OrderDate,101) AS 'OrderDate'
--	 ,DATEDIFF(DAY, CONVERT(varchar(10),so.OrderDate,101), @EndDate) AS 'DaysPending'
      ,COUNT(sod.OrderDetailId) AS 'ATT'
FROM durp so
INNER JOIN catalog.Company cc ON cc.CarrierId = so.CarrierId
INNER JOIN salesorder.orderdetail sod ON sod.OrderId = so.OrderId AND sod.OrderDetailType = 'd'
INNER JOIN salesorder.[Order] sso ON sso.OrderId = so.OrderId
INNER JOIN salesorder.address sa ON sa.addressguid = sso.shipaddressguid
WHERE CONVERT(date,so.PendingDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
AND cc.CompanyName = 'Boost'
GROUP BY  cc.CompanyName, CONVERT(varchar(10),so.OrderDate,101);

WITH durp (PendingDate,OrderDate,OrderId,ActivationType,CarrierId) AS (
SELECT DISTINCT CONVERT(VARCHAR(10),ChangeDate,101) AS 'PendingDate', OrderDate,OrderId, ActivationType, CarrierId FROM logging.orders 
WHERE Status IN ('1','2') AND GERSStatus = '0' AND ActivationType NOT IN ('E')
AND OrderId NOT IN (SELECT DISTINCT OrderId FROM logging.orders WHERE Status IN ('3','4'))
AND CONVERT(date,ChangeDate,101) BETWEEN DATEADD(DAY,-1,@StartDate) AND DATEADD(DAY,-1,@EndDate)
)

SELECT DISTINCT
CONVERT(varchar(10),d.OrderDate,101) AS 'OrderDate'
,ISNULL(a.Carrier,'0') AS 'ATT'
,ISNULL(v.Carrier,'0') AS 'Verizon'
,ISNULL(s.Carrier,'0') AS 'Sprint'
,ISNULL(b.Carrier,'0') AS 'Boost'
FROM durp d
LEFT JOIN @ATT a ON a.OrderDate = CONVERT(varchar(10),d.OrderDate,101)
LEFT JOIN @Verizon v ON v.OrderDate = CONVERT(varchar(10),d.OrderDate,101)
LEFT JOIN @Boost b ON b.OrderDate = CONVERT(varchar(10),d.OrderDate,101)
LEFT JOIN @Sprint s ON s.OrderDate = CONVERT(varchar(10),d.OrderDate,101)

		
end