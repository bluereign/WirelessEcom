
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [PAGEMASTER].[ServiceMaster] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '5' AND p.Active = '1')

SELECT
	csm.ServiceMasterGuid
	,csm.ServiceMasterGroupGuid
	,csm.Label
	,pr.ProductGuid AS 'ServiceGuid'
	,csm.Ordinal
FROM
	catalog.ServiceMaster csm
INNER JOIN ParentGuid pr ON pr.ParentProductGuid = csm.ServiceGuid





GO
