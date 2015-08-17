

CREATE  view [dbo].[FourteendaysSalesAccessory_View]      
as      
      
SELECT   od.GersSku,  COUNT(1) AS Units_14   
  FROM  salesorder.[Order] AS o WITH (NOLOCK)    
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId  and od.OrderDetailType='a' 
          INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101) BETWEEN  convert(varchar(10),GETDATE()-14,101) and convert(varchar(10),GETDATE(),101)  
    and OD.RetailPrice <>0 and OD.ProductTitle not like '%free kit%' 
group by od.GersSku