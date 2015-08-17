


CREATE  proc [maintenance].[WebLinkFailure_Minus_2_usp]
 --@OrderID INT
--,@OrderDetailId INT
as 
/*************************************************
Proc name    : [maintenance].[WebLinkFailure_Minus_2_usp]
Server Name  : 10.7.0.62
DB Name      : CarToys
Created By   : Sekar Muniyandi
Created Date : Map 3st, 2011
Description  : Missing Allocation 
Modified Date: None

Test Before  Update:

SELECT * FROM salesorder.OrderStatus
SELECT * FROM salesorder.[Order] o
WHERE o.GERSStatus IN (-2)

DECLARE @OrderId as int
SET @OrderId = 48004  

select * from salesorder.[Order] where OrderId = @OrderId
select * from salesorder.WirelessAccount where OrderId = @OrderId

select * from salesorder.OrderDetail with (nolock) where OrderId = @OrderId
select * from salesorder.WirelessLine with (nolock) where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)
select * from salesorder.LineService  with (nolock) where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)

select * from salesorder.Payment with (nolock) where OrderId = @OrderId
select * from catalog.GersStock with (nolock) where OrderDetailId IN (select OrderDetailId from salesorder.OrderDetail where OrderId = @OrderId)


-- Get Order Detail Items with no allocated GERS Stock
SELECT *
FROM salesorder.OrderDetail od with (nolock)
LEFT JOIN catalog.GersStock gs with (nolock) ON gs.OrderDetailId = od.OrderDetailId
WHERE
gs.OrderDetailId IS NULL
AND od.OrderId = 48083              
AND od.OrderDetailType IN ('d', 'a')

SELECT * FROM catalog.GersStock gs with (nolock) WHERE gs.GersSku = 'VINCRED2K' AND OrderDetailId IS NULL

**************************************************/
BEGIN


UPDATE catalog.GersStock
SET OrderDetailId = '234552'
WHERE OutletId = '0517199416'  --pick any OutletID (SELECT * FROM catalog.GersStock gs WHERE gs.GersSku = 'VINCRED2K' AND OrderDetailId IS NULL)
 AND GersSku = 'VINCRED2K'

UPDATE salesorder.[Order]
SET GERSStatus = 0
WHERE OrderId = 48083 

END
      
      
--SELECT OrderDate, o.OrderId, Status, * FROM catalog.GersStock gs 
--INNER JOIN salesorder.OrderDetail od ON od.OrderDetailId = gs.OrderDetailId
--INNER JOIN salesorder.[Order] o ON o.OrderId = od.OrderId
--WHERE gs.GersSku = 'xxxxxx' and Status = 4

--UPDATE catalog.GersStock
--SET OrderDetailId = null
--WHERE OrderDetailId IN
--(
--	SELECT gs.OrderDetailId FROM catalog.GersStock gs 
--	INNER JOIN salesorder.OrderDetail od ON od.OrderDetailId = gs.OrderDetailId
--	INNER JOIN salesorder.[Order] o ON o.OrderId = od.OrderId
--	WHERE gs.GersSku = 'xxxxxx' and Status = 4
--)

--Use this to trouble shoot order 48033.

--Check stock
SELECT * FROM catalog.GersStock gs WHERE gs.GersSku = 'TMYTHHDWK'


--Check for inventory on cancelled orders that did not release stock
SELECT OrderDate, o.OrderId, Status, * FROM catalog.GersStock gs 
INNER JOIN salesorder.OrderDetail od ON od.OrderDetailId = gs.OrderDetailId
INNER JOIN salesorder.[Order] o ON o.OrderId = od.OrderId
WHERE gs.GersSku = 'TMYTHHDWK' and Status = 4

--Release stock from cancelled orders
UPDATE catalog.GersStock
SET OrderDetailId = null
WHERE OrderDetailId IN
(
	SELECT gs.OrderDetailId FROM catalog.GersStock gs 
	INNER JOIN salesorder.OrderDetail od ON od.OrderDetailId = gs.OrderDetailId
	INNER JOIN salesorder.[Order] o ON o.OrderId = od.OrderId
	WHERE gs.GersSku = 'BSDRD2BKT' and Status = 4
)


--Use this to check against cancelled orders for stock.

--GersSKU update
UPDATE salesorder.OrderDetail
SET ProductId = 4651
      , GersSku = 'TMYTHDWKT' -- new
WHERE GersSku = 'TMYTHHDWK' --old 
and OrderDetailId = 229927





