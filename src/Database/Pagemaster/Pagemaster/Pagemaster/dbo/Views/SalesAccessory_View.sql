
   
CREATE view  [dbo].[SalesAccessory_View]    
as     
    
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