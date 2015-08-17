
CREATE VIEW [Inventory].[Devices] AS

WITH Sales_Viewv AS (
SELECT     
                 P.GersSku              
                --, D.Name    
                , IsNull((select value from catalog.Property where Name = 'Title' and ProductGuid = d.DeviceGuid),'') as Name
  
                , ISNULL(i.OnHandQty,0)   as  'On Hand Qty'           
                , ISNULL(I.AvailableQty, 0) AS 'Avail Qty'             
                ,(SELECT DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECN' AND gp.GersSku = P.GersSku) Newprice  
                ,(SELECT  DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECU' AND gp.GersSku = P.GersSku) upgradeprice  
                ,(SELECT DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ECA' AND gp.GersSku = P.GersSku) Addalineprice  
                , (SELECT DISTINCT gp.Price FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'COG' AND gp.GersSku = P.GersSku) CogsPrice  
                , ISNULL(I.HoldBackQty, 0) AS HoldBack  
                ,  P.ProductId AS ProdID  
FROM  
                catalog.Product AS P INNER JOIN  
                catalog.dn_AllProducts AS D ON P.ProductGuid = D.DeviceGuid LEFT OUTER JOIN  
                catalog.Inventory AS I ON I.ProductId = P.ProductId  
                LEFT OUTER JOIN catalog.Property AS R ON R.ProductGuid=D.DeviceGuid AND R.Name='LaunchDate'  
                LEFT OUTER JOIN catalog.Property AS T ON T.ProductGuid=D.DeviceGuid AND T.Name='EOLDate'  
WHERE  
                (P.Active = 1 OR I.OnHandQty > 0) AND  P.GersSku IS NOT NULL  
                AND (T.Value IS NULL OR I.AvailableQty+I.HoldBackQty>0 ) 
				
)
,onedaysales_viewv AS (
SELECT   od.GersSku,  COUNT(1) AS Units_1 
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
  INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101)  between   convert(varchar(10),GETDATE()-1,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('d')  
group by od.GersSku)
,sevendayssales_viewv AS (
SELECT   od.GersSku,  COUNT(1) AS Units_7
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
    INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101)  between   convert(varchar(10),GETDATE()-7,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('d')  
group by od.GersSku)
,fourteendayssales_viewv AS (
SELECT   od.GersSku,  COUNT(1) AS Units_14 
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
        INNER JOIN salesorder.gersorderstatus sgs ON sgs.DEL_DOC_NUM = o.GERSRefNum
  WHERE  CONVERT(varchar(10),sgs.FINAL_DT,101) BETWEEN convert(varchar(10),GETDATE()-14,101) and convert(varchar(10),GETDATE(),101)
    AND od.OrderDetailType   in('d')  
  group by od.GersSku)
  

SELECT  SV.GERSSKU AS 'GersSKU'
,SV.NAME AS 'Product Name'
,sv.[on hand qty] [OnHandQty]
,SV.HOLDBACK [HoldBackValue]
,ISNULL(VP.Units_1,0) [SalesPending]
,(select reservedqty from catalog.inventory where gerssku = sv.gerssku) AS 'ReservedForCheckout'
,CASE WHEN (SV.[AVAIL QTY]-ISNULL(VP.Units_1,0)) < '0' THEN '0' ELSE (SV.[AVAIL QTY]-ISNULL(VP.Units_1,0))  END AS [UnitsAvailableforSale]
,ISNULL(V1.UNITS_1,0) [FinalizedSalesYesterday]
,ISNULL(V7.UNITS_7,0) [FinalizedSalesPast7Days]
,ISNULL(V14.UNITS_14,0) [FinalizedSalesPast14Days]
, case when convert(int, (ISNULL(V7.UNITS_7,0) * 3.5) -  SV.[AVAIL QTY]) >0
  then convert(int, (ISNULL(V7.UNITS_7,0) * 3.5) -  SV.[AVAIL QTY])   else '0'
  end 'Recommend Order'  
,CASE WHEN (SELECT Tag from catalog.producttag cpt INNER JOIN catalog.product cp ON cp.productguid = cpt.productguid WHERE cp.GersSku = sv.GersSku AND Tag = 'closeout') IS NULL
THEN '' ELSE (SELECT Tag from catalog.producttag cpt INNER JOIN catalog.product cp ON cp.productguid = cpt.productguid WHERE cp.GersSku = sv.GersSku AND Tag = 'closeout')
end 'Closeout'
,
CASE
WHEN (SELECT DISTINCT COUNT(*) from catalog.producttag cpt INNER JOIN catalog.product cp ON cp.productguid = cpt.productguid WHERE cp.GersSku = sv.GersSku AND Tag IN ('online','warehouse')) = '2'
THEN 'Online/Warehouse'
WHEN (SELECT Tag from catalog.producttag cpt INNER JOIN catalog.product cp ON cp.productguid = cpt.productguid WHERE cp.GersSku = sv.GersSku AND Tag IN ('online','warehouse')) = 'Online'
THEN 'Online'
WHEN (SELECT Tag from catalog.producttag cpt INNER JOIN catalog.product cp ON cp.productguid = cpt.productguid WHERE cp.GersSku = sv.GersSku AND Tag IN ('online','warehouse')) = 'Warehouse'
THEN 'Warehouse'
ELSE '---'
END 'Availability'
,SV.NEWPRICE [NEW PRICE]
,ISNULL((SELECT DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ERN' AND gp.GersSku = sv.GersSku),sv.NewPrice) AS 'NEW PRICE AFTER REBATE'
,SV.UPGRADEPRICE [UPGRADE PRICE]	
,ISNULL((SELECT DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ERU' AND gp.GersSku = sv.GersSku),sv.UpgradePrice) AS 'UPGRADE PRICE AFTER REBATE'
,SV.ADDALINEPRICE [ADD A LINE PRICE]
,ISNULL((SELECT DISTINCT MAX(gp.Price) FROM catalog.GersPrice gp WHERE gp.EndDate > GETDATE() and gp.PriceGroupCode = 'ERA' AND gp.GersSku = sv.GersSku),sv.AddALinePrice) AS 'ADDALINE PRICE AFTER REBATE'
,SV.COGSPRICE [COGS PRICE] 
,SV.PRODID [PRODUCT ID]
, (SELECT COUNT(OutletId) FROM catalog.GersStock WHERE OrderDetailId IS NULL AND OutletId LIKE 'FK%' AND GersSku = sv.GersSku) AS 'FAKE UNITS FOR SALE' 
,ISNULL((SELECT COUNT(OutletId) FROM catalog.GersStock WHERE OrderDetailId IS NOT NULL AND OutletId LIKE 'FK%' AND GersSku = sv.GersSku),'0') AS 'FAKE UNITS ORDERED'
,ISNULL((SELECT DISTINCT Active from catalog.product p WHERE p.GersSku = sv.GersSku),'0') 'Active'
FROM SALES_VIEWv SV
LEFT  JOIN FOURTEENDAYSSALES_VIEWv  V14 ON  SV.GERSSKU=V14.GERSSKU
LEFT JOIN  SEVENDAYSSALES_VIEWv  V7 ON  SV.GERSSKU=V7.GERSSKU
LEFT JOIN ONEDAYSALES_VIEWv   V1 ON SV.GERSSKU=V1.GERSSKU
LEFT JOIN (SELECT   od.GersSku,  COUNT(1) AS Units_1 
  FROM  salesorder.[Order] AS o WITH (NOLOCK)  
  INNER JOIN salesorder.OrderDetail AS OD WITH (NOLOCK) ON o.OrderId = od.OrderId 
  WHERE  od.OrderDetailType   in('d')  
    AND o.Status IN (1,2)
group by od.GersSku) vp ON sv.gerssku = vp.gerssku
WHERE 	sv.gerssku in (Select gerssku from catalog.product where active = '1')