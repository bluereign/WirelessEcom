
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/* Push Static Data to catalog.Image */

CREATE VIEW [AAFES].[Image] AS

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
WHERE p.ChannelID = '3')


SELECT
	i.ImageGuid
	,pp.ProductGuid AS 'ReferenceGuid'
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
INNER JOIN ParentGuid pp ON pp.ParentProductGuid = i.ReferenceGuid OR pp.ProductGuid = i.ReferenceGuid
WHERE pp.ChannelId = '3' AND i.binImage IS NOT NULL




GO
