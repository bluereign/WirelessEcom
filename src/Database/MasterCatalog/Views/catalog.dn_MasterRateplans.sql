SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [catalog].[dn_MasterRateplans] AS

SELECT cd.Title AS 'Name', c.CarrierId, cp.ChannelID, cd.RateplanGuid, cpg.ProductTypeId, ISNULL(cpc.ParentProductGuid,cp.ProductGuid) AS 'MatchingGUID', cd.CarrierBillCode AS 'SOC Code', ISNULL(c.CompanyName, '') AS Carrier, ISNULL(cpy.Value, cd.Title) AS Title, ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           INNER JOIN catalog.ProducttoParentChannel cpc ON cpc.ParentProductGuid = cp.ProductGuid
                           INNER JOIN catalog.Rateplan cd ON cd.RateplanGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cpc.ParentProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.CarrierGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
                           UNION 
                           SELECT  cd.Title, c.CarrierId, cp.ChannelID, cd.RateplanGuid, cpg.ProductTypeId, ISNULL(cpcc.ParentProductGuid,cp.ProductGuid) AS 'MatchingGUID', cd.CarrierBillCode AS 'SOC COde', ISNULL(c.CompanyName, '') AS Carrier
                           ,ISNULL(cpy.Value,(
                           SELECT MAX(ISNULL(py.Value,d.Title))
                           FROM catalog.Product p
                           INNER JOIN catalog.ProducttoParentChannel capc ON capc.ParentProductGuid = p.ProductGuid
                           INNER JOIN catalog.Rateplan d ON d.RateplanGuid = p.ProductGuid AND d.Title IS NOT NULL
                           LEFT JOIN catalog.Property py ON py.ProductGuid = capc.ParentProductGuid AND py.Name = 'title' AND py.Value IS NOT NULL
                           WHERE p.ProductGuid = cpcc.ParentProductGuid
                           )) AS Title
                           ,ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           LEFT JOIN catalog.ProducttoParentChannel cpcc ON cpcc.ProductGuid = cp.ProductGuid
                           INNER JOIN catalog.Rateplan cd ON cd.RateplanGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cpcc.ProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.CarrierGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
                           WHERE ISNULL(cpy.Value,(
                           SELECT MAX(ISNULL(py.Value,d.Title))
                           FROM catalog.Product p
                           INNER JOIN catalog.ProducttoParentChannel capc ON capc.ParentProductGuid = p.ProductGuid
                           INNER JOIN catalog.Rateplan d ON d.RateplanGuid = p.ProductGuid AND d.Title IS NOT NULL
                           LEFT JOIN catalog.Property py ON py.ProductGuid = capc.ParentProductGuid AND py.Name = 'title' AND py.Value IS NOT NULL
                           WHERE p.ProductGuid = cpcc.ParentProductGuid
                           )) IS NOT NULL
UNION
SELECT cd.Title AS 'Name', c.CarrierId, cp.ChannelID, cd.RateplanGuid, cpg.ProductTypeId, cp.ProductGuid AS 'MatchingGUID', cd.CarrierBillCode AS 'SOC Code', ISNULL(c.CompanyName, '') AS Carrier, ISNULL(cd.Title,'') AS Title, ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           INNER JOIN catalog.Rateplan cd ON cd.RateplanGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.CarrierGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
WHERE cp.ChannelID = '0'                          



GO
