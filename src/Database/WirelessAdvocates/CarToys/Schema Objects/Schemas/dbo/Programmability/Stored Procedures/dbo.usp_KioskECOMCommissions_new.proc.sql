  
CREATE PROCEDURE [dbo].[usp_KioskECOMCommissions_new]   
 --  @OrderBeginDate date = NULL  
 --, @OrderEndDate date = NULL  
 @EmployeeID varchar(6) = NULL  
AS  
 --SET @OrderBeginDate = ISNULL(@OrderBeginDate, CONVERT(datetime, 0))  
 --SET @OrderEndDate = ISNULL(@OrderEndDate, GETDATE())  
   
 SELECT KS.DISTRICT AS [WA District:]  
  , KS.KioskNumber AS Kiosk  
  , KS.STORE_NAME AS [Wa Store Name:]  
  , KS.EMP_CD AS [Emp Cd:]  
  , O.OrderDate  
  , O.GersRefNum AS [Del Doc Number]  
  , OD.GersSku AS [Item Cd:]  
  , OD.Qty  
 FROM salesorder.[Order] O  
  INNER JOIN salesorder.OrderDetail OD on O.OrderId = OD.OrderId  
  LEFT OUTER JOIN gers.KioskStaff KS ON LEFT(O.KioskEmployeeNumber,8) = KS.EMP_INIT  
 WHERE O.KioskEmployeeNumber IS NOT NULL  
  AND OD.OrderDetailType IN ('r','s')  
  --AND CONVERT(date, O.OrderDate) >= @OrderBeginDate  
  --AND CONVERT(date, O.OrderDate) <= @OrderEndDate  
  AND SUBSTRING(O.KioskEmployeeNumber,3,6) = ISNULL(@EmployeeId, SUBSTRING(O.KioskEmployeeNumber,3,6))  