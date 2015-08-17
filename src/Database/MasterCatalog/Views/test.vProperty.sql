SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW test.vProperty
AS
WITH MasterProperties AS
(
	SELECT P.PropertyGuid
		, ISNULL(PPC.ProductGuid, PROD.ProductGuid) AS ProductGuid
		, P.IsCustom
		, P.LastModifiedDate
		, P.LastModifiedBy
		, P.Name
		, P.Value
		, P.Active
		, PROD.ChannelID
	FROM catalog.Product PROD
		LEFT OUTER JOIN catalog.ProducttoParentChannel PPC ON PROD.ProductGuid = PPC.ProductGuid
		LEFT OUTER JOIN catalog.Property P ON PPC.ParentProductGuid = P.ProductGuid
	WHERE P.Name NOT IN ('sort.EditorsChoiceAccessories','sort.EditorsChoice','Inventory.HoldBackQty','C780F29A-904B-4357-990B-EA9E440992C4') -- these properties should never come from master
) 
, ChannelProperties AS
(
	SELECT P.PropertyGuid
		, P.ProductGuid
		, P.IsCustom
		, P.LastModifiedDate
		, P.LastModifiedBy
		, P.Name
		, P.Value
		, P.Active
		, PROD.ChannelId
	FROM catalog.Product PROD
		INNER JOIN catalog.Property P ON PROD.ProductGuid = P.ProductGuid
)
SELECT ISNULL(MP.PropertyGuid, CP.PropertyGuid) AS PropertyGuid
	, ISNULL(MP.ProductGuid, CP.ProductGuid) AS ProductGuid
	, ISNULL(MP.IsCustom, CP.IsCustom) AS IsCustom
	, ISNULL(MP.LastModifiedDate, CP.LastModifiedDate) AS LastModifiedDate
	, ISNULL(MP.LastModifiedBy, CP.LastModifiedBy) AS LastModifiedBy
	, ISNULL(MP.Name, CP.Name) AS Name
	, (CASE WHEN CP.Name = 'shortdescription' AND LEN(CP.Value) <> LEN(MP.Value) AND CP.Value <> '' THEN CP.Value
			WHEN CP.Name = 'longdescription' AND LEN(CP.Value) <> LEN(MP.Value) AND CP.Value <> '' THEN CP.Value
			WHEN CP.Name = 'title' AND CP.Value <> MP.Value AND CP.Value <> '' THEN CP.Value
			WHEN CP.Name = 'title' AND CP.Value <> '' AND CP.Value <> (SELECT Name FROM catalog.Device WHERE DeviceGuid = CP.ProductGuid) THEN CP.Value
		ELSE ISNULL(MP.Value, CP.Value) END) AS Value
	, ISNULL(MP.Active, CP.Active) AS Active
	, ISNULL(MP.ChannelId, CP.ChannelId) AS ChannelId
FROM MasterProperties MP
	FULL OUTER JOIN ChannelProperties CP ON MP.ProductGuid = CP.ProductGuid AND MP.Name = CP.Name
;
GO
