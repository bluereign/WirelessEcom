SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.ProductGuid */

CREATE VIEW [AAFES].[ProductGuid] AS

SELECT
	pp.ProductGuid AS 'ProductGuid'
	,pg.ProductTypeId
FROM
	catalog.ProductGuid pg
INNER JOIN catalog.Product pp ON pp.ProductGuid = pg.ProductGuid
WHERE pp.ChannelId = '3'
GO
