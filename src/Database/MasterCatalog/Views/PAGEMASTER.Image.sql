
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












/* Push Static Data to catalog.Image */

CREATE VIEW [PAGEMASTER].[Image] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT DISTINCT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '5')

SELECT
	i.ImageGuid
	,ISNULL(pp.ProductGuid,cp.ProductGuid) AS 'ReferenceGuid'
	,i.IsActive
	,i.IsPrimaryImage
	,i.Title
	,i.Caption
	,i.Alt
	,i.OriginalHeight
	,i.OriginalWidth
	,i.CreatedDate
	,i.CreatedBy
	,i.Ordinal
	,i.binImage
FROM
	catalog.Image i
LEFT JOIN ParentGuid pp ON pp.ParentProductGuid = i.ReferenceGuid OR pp.ProductGuid = i.ReferenceGuid AND i.IsActive = '1'
LEFT JOIN catalog.Product cp ON cp.ProductGuid = i.ReferenceGuid AND cp.ChannelID = '5' AND i.IsActive = '1'
WHERE
(cp.ChannelId = '5' AND i.binImage IS NOT NULL AND i.IsActive = '1')
OR pp.ProductGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = '5')
OR pp.ParentProductGuid IN (SELECT ProductGuid FROM catalog.Product WHERE ChannelID = '5')
OR cp.ProductGuid IN (SELECT cpt.ProductGuid FROM catalog.ProductTag cpt WHERE Tag = 'freeaccessory')
AND i.IsActive = '1'
AND i.CreatedBy ='dev'













GO
