
CREATE  view [dbo].[SevendaysSales_View]    
as    
    
SELECT   od.GersSku,  COUNT(1) AS Units_7
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
  WHERE  o.OrderDate  between   convert(varchar(10),GETDATE()-7,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('d')  
    AND o.Status IN (2,3)
group by od.GersSku