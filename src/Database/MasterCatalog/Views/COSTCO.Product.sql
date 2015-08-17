SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.Product */

CREATE VIEW [COSTCO].[Product] AS

SELECT
	p.ProductId
	,p.ProductGuid
	,p.GersSku
	,p.Active
FROM
	catalog.Product p
WHERE p.ChannelID = '2'

GO
