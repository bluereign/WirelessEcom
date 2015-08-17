SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW catalog.dn_MasterAccessories AS

SELECT cd.name, c.CarrierId, cp.ChannelID, cd.accessoryGuid, cpg.ProductTypeId, ISNULL(cpc.ParentProductGuid,cp.ProductGuid) AS 'MatchingGUID', cd.UPC, ISNULL(c.CompanyName, '') AS Manufacturer, ISNULL(cpy.Value, cd.Name) AS Title, ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           INNER JOIN catalog.ProducttoParentChannel cpc ON cpc.ParentProductGuid = cp.ProductGuid
                           INNER JOIN catalog.accessory cd ON cd.accessoryGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cpc.ParentProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.ManufacturerGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
                           UNION 
                           SELECT  cd.name, c.CarrierId, cp.ChannelID, cd.accessoryGuid, cpg.ProductTypeId, ISNULL(cpcc.ParentProductGuid,cp.ProductGuid) AS 'MatchingGUID', cd.UPC, ISNULL(c.CompanyName, '') AS Carrier
                           ,ISNULL(cpy.Value,(
                           SELECT MAX(ISNULL(py.Value,d.Name))
                           FROM catalog.Product p
                           INNER JOIN catalog.ProducttoParentChannel capc ON capc.ParentProductGuid = p.ProductGuid
                           INNER JOIN catalog.accessory d ON d.accessoryGuid = p.ProductGuid AND d.Name IS NOT NULL
                           LEFT JOIN catalog.Property py ON py.ProductGuid = capc.ParentProductGuid AND py.Name = 'title' AND py.Value IS NOT NULL
                           WHERE p.ProductGuid = cpcc.ParentProductGuid
                           )) AS Title
                           ,ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           LEFT JOIN catalog.ProducttoParentChannel cpcc ON cpcc.ProductGuid = cp.ProductGuid
                           INNER JOIN catalog.accessory cd ON cd.accessoryGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cpcc.ProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.ManufacturerGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
                           WHERE ISNULL(cpy.Value,(
                           SELECT MAX(ISNULL(py.Value,d.Name))
                           FROM catalog.Product p
                           INNER JOIN catalog.ProducttoParentChannel capc ON capc.ParentProductGuid = p.ProductGuid
                           INNER JOIN catalog.accessory d ON d.accessoryGuid = p.ProductGuid AND d.Name IS NOT NULL
                           LEFT JOIN catalog.Property py ON py.ProductGuid = capc.ParentProductGuid AND py.Name = 'title' AND py.Value IS NOT NULL
                           WHERE p.ProductGuid = cpcc.ParentProductGuid
                           )) IS NOT NULL
UNION
SELECT cd.name, c.CarrierId, cp.ChannelID, cd.accessoryGuid, cpg.ProductTypeId, cp.ProductGuid AS 'MatchingGUID', cd.UPC, ISNULL(c.CompanyName, '') AS Carrier, ISNULL(cd.Name,'') AS Title, ISNULL(cp.GersSku,'') AS 'GersSKU', cp.ProductId, cch.Channel, cp.Active, cp.CreateDate
                           FROM catalog.Product cp
                           INNER JOIN catalog.accessory cd ON cd.accessoryGuid = cp.ProductGuid
                           LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'title'
                           LEFT JOIN catalog.Company AS c ON c.CompanyGuid = cd.ManufacturerGuid
                           LEFT JOIN catalog.Channel AS cch ON cp.ChannelID = cch.ChannelId
                           LEFT JOIN catalog.ProductGuid cpg ON cpg.ProductGuid = cp.ProductGuid
WHERE cp.ChannelID = '0'                          



GO
