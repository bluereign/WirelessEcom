
CREATE  view [dbo].[SevendaysSalesAccessory_View]      
as      
      
SELECT   od.GersSku,  COUNT(1) AS Units_7  
  FROM  salesorder.[Order] AS o WITH (NOLOCK)    
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId   and od.OrderDetailType='a'  
 WHERE  o.OrderDate  between   convert(varchar(10),GETDATE()-7,101) and convert(varchar(10),GETDATE(),101)  
     and o.Status IN (1,2,3)  and  OD.RetailPrice <>0 and OD.ProductTitle not like '%free kit%' 
     and  od.ProductTitle is not null 
      and  o.ActivationType<>'e'
group by od.GersSku