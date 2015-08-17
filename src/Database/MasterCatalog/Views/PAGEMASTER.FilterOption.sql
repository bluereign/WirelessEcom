
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/* Push Static Data to catalog.FilterOption */

CREATE VIEW [PAGEMASTER].[FilterOption] AS

SELECT DISTINCT
	cfo.FilterOptionId
	,cfo.FilterGroupId
	,cfo.Label
	,cfo.Tag
	,cfo.DynamicTag
	,cfo.Ordinal
	,cfc.Active
FROM
	catalog.FilterOption cfo
INNER JOIN catalog.FilterChannel cfc ON cfc.FilterOptionId = cfo.FilterOptionId
WHERE cfc.ChannelID = '5'







GO
