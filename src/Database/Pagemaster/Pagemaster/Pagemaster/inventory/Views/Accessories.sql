
CREATE VIEW Inventory.Accessories AS

WITH salesaccessory_viewv AS (
SELECT       
                 P.GersSku                
                , D.Name      
                , ISNULL(i.OnHandQty,0)   as  'On Hand Qty'             
                , ISNULL(I.AvailableQty, 0) AS 'Avail Qty'               
                ,(SELECT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECN' AND gp.GersSku = P.GersSku) Newprice    
                ,(SELECT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECU' AND gp.GersSku = P.GersSku) upgradeprice    
                ,(SELECT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECA' AND gp.GersSku = P.GersSku) Addalineprice    
                , (SELECT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECP' AND gp.GersSku = P.GersSku) ECPPrice    
                , (SELECT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'COG' AND gp.GersSku = P.GersSku) CogsPrice    
                , ISNULL(I.HoldBackQty, 0) AS HoldBack    
                ,  P.ProductId AS ProdID    
FROM    
                catalog.Product AS P INNER JOIN    
                catalog.Accessory AS D ON P.ProductGuid = D.AccessoryGuid LEFT OUTER JOIN    
                catalog.Inventory AS I ON I.ProductId = P.ProductId    
                LEFT OUTER JOIN catalog.Property AS R ON R.ProductGuid=D.AccessoryGuid AND R.Name='LaunchDate'    
                LEFT OUTER JOIN catalog.Property AS T ON T.ProductGuid=D.AccessoryGuid AND T.Name='EOLDate'    
WHERE    
                (P.Active = 1 OR I.OnHandQty > 0) AND  P.GersSku IS NOT NULL    
                AND (T.Value IS NULL OR I.AvailableQty+I.HoldBackQty>0 )    and D.Name  not like '%Free Kit%'
)
,OnedaySalesAccessory_Viewv AS (        
SELECT   od.GersSku,  COUNT(1) AS Units_1   
  FROM  salesorder.[Order] AS o WITH (NOLOCK)    
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId  and od.OrderDetailType='a' 
  INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101)  between   convert(varchar(10),GETDATE()-1,101) and convert(varchar(10),GETDATE(),101)
     AND OD.RetailPrice <>0 and OD.ProductTitle not like '%free kit%' 
     and  od.ProductTitle is not null 
group by od.GersSku
)
,SevendaysSalesAccessory_Viewv AS (
SELECT   od.GersSku,  COUNT(1) AS Units_7  
  FROM  salesorder.[Order] AS o WITH (NOLOCK)    
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId   and od.OrderDetailType='a'  
      INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101) BETWEEN convert(varchar(10),GETDATE()-7,101) and convert(varchar(10),GETDATE(),101)  
     and OD.RetailPrice <>0 and OD.ProductTitle not like '%free kit%' 
     and  od.ProductTitle is not null 
group by od.GersSku  
)
,FourteendaysSalesAccessory_Viewv AS (
SELECT   od.GersSku,  COUNT(1) AS Units_14   
  FROM  salesorder.[Order] AS o WITH (NOLOCK)    
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId  and od.OrderDetailType='a' 
          INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101) BETWEEN  convert(varchar(10),GETDATE()-14,101) and convert(varchar(10),GETDATE(),101)  
    and OD.RetailPrice <>0 and OD.ProductTitle not like '%free kit%' 
group by od.GersSku
)


SELECT DISTINCT SV.GERSSKU AS 'GersSku'
,(SELECT MAX(Value) FROM catalog.property cpy INNER JOIN catalog.product cp ON cp.GersSku = sv.GersSku WHERE Name = 'title' and cpy.ProductGuid = cp.ProductGuid) 'Product Name'
,(SELECT COUNT(*) FROM catalog.gersstock WHERE GersSku = sv.GersSku AND OrderDetailId IS NULL) AS 'OnHandQty'
,isnull(SV.HOLDBACK,0) AS 'HoldBackValue'
,ISNULL(VP.Units_1,0) AS 'SalesPending'
,(select max(reservedqty) from catalog.inventory where gerssku = sv.gerssku) AS 'ReservedForCheckout'
,CASE WHEN (SV.[AVAIL QTY]-ISNULL(VP.Units_1,0)) < '0' THEN '0' ELSE (SV.[AVAIL QTY]-ISNULL(VP.Units_1,0)) END [UnitsAvailableforSale]
,ISNULL(V1.UNITS_1,0) AS 'FinalizedSalesYesterday'
,ISNULL(V7.UNITS_7,0) AS 'FinalizedSalesPast7Days'
,ISNULL(V14.UNITS_14,0) AS 'FinalizedSalesPast14Days'
,(SELECT ISNULL(CONVERT(varchar(10),MAX(ppo.OrderDate),101),'0 BOUGHT') FROM salesorder.[Order] ppo INNER JOIN salesorder.OrderDetail ppd ON ppd.OrderId = ppo.OrderId
WHERE ppo.Status = '3' and ppo.GERSStatus = '3' and ppd.GersSku = sv.gerssku) AS 'Last Known Customer Purchase'
--, case when convert(int, (ISNULL(V7.UNITS_7,0) * 3.5) -  SV.[AVAIL QTY]) >0   then convert(int, (ISNULL(V7.UNITS_7,0) * 3.5) -  SV.[AVAIL QTY])   else '0'   end 'Recommend Order'    
,isnull(SV.ECPPRICE,0) [Net Price]
,isnull(SV.COGSPRICE,0) [COGS Price] 
,SV.PRODID [PRODUCT ID]
FROM SALESAccessory_VIEWv SV
left  JOIN FourteendaysSalesAccessory_Viewv  V14 ON  SV.GERSSKU=V14.GERSSKU
LEFT JOIN  SevendaysSalesAccessory_Viewv  V7 ON  SV.GERSSKU=V7.GERSSKU
LEFT JOIN OnedaySalesAccessory_Viewv   V1 ON SV.GERSSKU=V1.GERSSKU
LEFT JOIN (SELECT   od.GersSku,  COUNT(1) AS Units_1 
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
  WHERE  o.OrderDate  between   convert(varchar(10),GETDATE()-365,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('a')  
    AND (o.Status IN ('1','2') OR o.GersSTatus IN ('-1','-2','-3','-4','-5','-6'))
    AND od.orderdetailid IN (select orderdetailid from catalog.gersstock)
group by od.GersSku) vp ON sv.gerssku = vp.gerssku

where 
sv.GersSku IN (SELECT GersSku FROM catalog.Product WHERE Active = '1' AND ProductGuid NOT IN(SELECT ProductGuid FROM catalog.ProductTag WHERE Tag = 'FREEACCESSORY'))