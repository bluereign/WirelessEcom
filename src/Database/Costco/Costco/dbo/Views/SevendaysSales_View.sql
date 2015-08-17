


CREATE  view [dbo].[SevendaysSales_View]    
as    
    
SELECT   od.GersSku,  COUNT(1) AS Units_7
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
    INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101)  between   convert(varchar(10),GETDATE()-7,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('d')  
group by od.GersSku