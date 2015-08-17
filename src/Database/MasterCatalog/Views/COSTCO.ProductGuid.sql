SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.ProductGuid */

CREATE VIEW [COSTCO].[ProductGuid] AS

SELECT
	pg.ProductGuid
	,pg.ProductTypeId
FROM
	catalog.ProductGuid pg
INNER JOIN catalog.Product cp ON cp.ProductGuid = pg.ProductGuid
WHERE cp.ChannelId = '2'

GO
