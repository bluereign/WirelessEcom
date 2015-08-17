
  
CREATE PROCEDURE [dbo].[usp_KioskECOMCommissions]         
   @OrderBeginDate date = NULL        
 , @OrderEndDate date = NULL        
 , @EmployeeID varchar(6) = NULL        
AS        
 SET @OrderBeginDate = ISNULL(@OrderBeginDate, CONVERT(datetime, 0))        
 SET @OrderEndDate = ISNULL(@OrderEndDate, GETDATE())        
         
    
    
SELECT       
   o.OrderId      
  , KS.DISTRICT AS [WA District:]        
  , KS.KioskNumber AS Kiosk        
  , KS.STORE_NAME AS [Wa Store Name:]        
  , KS.EMP_CD AS [Emp Cd:]        
  , O.OrderDate        
  , O.GersRefNum AS [Del Doc Number]        
  , OD.GersSku AS [Item Cd:]        
  , OD.Qty         
   ,OrderDetailType=    
 case OrderDetailType     
 when 's' then 'Service'    
 when 'r' then 'RatePlan'    
 when 'a' then 'Accessorry'    
 when 'u' then 'Upgrade'    
 end      
 FROM salesorder.[Order] O        
 INNER JOIN salesorder.OrderDetail OD on O.OrderId = OD.OrderId        
 LEFT OUTER JOIN gers.KioskStaff KS ON LEFT(ltrim(O.KioskEmployeeNumber),8) = KS.EMP_INIT        
 WHERE O.KioskEmployeeNumber IS NOT NULL        
  AND OD.OrderDetailType IN ('r','s','u','a')    and o.Status =3  and o.GERSStatus=3    
 and od.productid not in (    
 select  p.ProductId  from catalog.ProductTag  pt join catalog.Product p    
 on pt.ProductGuid =p.ProductGuid    
 where p.Productid=od.ProductId    
 and pt.Tag ='freeaccessory')     
     
  AND CONVERT(date, O.OrderDate) >= @OrderBeginDate        
  AND CONVERT(date, O.OrderDate) <= @OrderEndDate        
  AND SUBSTRING(ltrim(O.KioskEmployeeNumber),3,6) = ISNULL(@EmployeeId, SUBSTRING(ltrim(O.KioskEmployeeNumber),3,6))    
  
 union all  
  
 SELECT       
   o.OrderId      
  , KS.DISTRICT AS [WA District:]        
  , KS.KioskNumber AS Kiosk        
  , KS.STORE_NAME AS [Wa Store Name:]        
  , KS.EMP_CD AS [Emp Cd:]        
  , O.OrderDate        
  , O.GersRefNum AS [Del Doc Number]        
  , null [Item Cd:]        
  , 1     Qty   
  , 'Add a Line' OrderDetailType     
 FROM salesorder.[Order] O     
       
 LEFT OUTER JOIN gers.KioskStaff KS ON LEFT(ltrim(O.KioskEmployeeNumber),8) = KS.EMP_INIT        
 WHERE O.KioskEmployeeNumber IS NOT NULL        
   and  ActivationType='a'  and o.Status =3  and o.GERSStatus=3     
       
  AND CONVERT(date, O.OrderDate) >= @OrderBeginDate        
  AND CONVERT(date, O.OrderDate) <= @OrderEndDate        
  AND SUBSTRING(ltrim(O.KioskEmployeeNumber),3,6) = ISNULL(@EmployeeId, SUBSTRING(ltrim(O.KioskEmployeeNumber),3,6))    
  
order by 1