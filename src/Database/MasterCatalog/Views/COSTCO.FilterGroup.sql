SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Push Static Data to catalog.FilterGroup */

CREATE VIEW [COSTCO].[FilterGroup] AS

SELECT DISTINCT
	cfg.FilterGroupId
	,cfg.ProductType
	,cfg.Label
	,cfg.FieldName
	,cfg.AllowSelectMultiple
	,cfg.Ordinal
	,cfg.Active
FROM
	catalog.FilterGroup cfg
INNER JOIN catalog.FilterChannel cfc ON cfc.FilterGroupId = cfg.FilterGroupId
WHERE cfc.ChannelID = '2'
GO
