SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW catalog.dn_Filters AS

SELECT DISTINCT
	cfg.ProductType AS 'Product'
	,cfg.Label AS 'Filter Group'
	,cfo.Label AS 'Filter Name'
	,cfo.filteroptionid AS 'ID'
	,ISNULL((SELECT Channel FROM catalog.channel WHERE catalog.Channel.ChannelId = cfc.ChannelId),'Unassigned') AS 'Channel'
	,ISNULL(cfc.Active,'0') AS 'Active'
FROM catalog.FilterOption cfo
INNER JOIN catalog.FilterGroup cfg ON cfg.FilterGroupId = cfo.FilterGroupId
LEFT JOIN catalog.FilterChannel cfc ON cfc.FilterOptionId = cfo.FilterOptionId
GO
