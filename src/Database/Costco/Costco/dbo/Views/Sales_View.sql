




CREATE view  [dbo].[Sales_View]   as   

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