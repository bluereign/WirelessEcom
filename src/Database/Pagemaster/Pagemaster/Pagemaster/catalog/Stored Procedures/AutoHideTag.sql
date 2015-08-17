


create procedure [catalog].[AutoHideTag] 
AS

SET NOCOUNT ON

BEGIN TRAN;

/* Update 'autohide' tags */
WITH ExistingAutoHideTags AS
(
	SELECT ProductGuid, Tag
	FROM catalog.ProductTag
	WHERE Tag = 'autohide'
)
,  PhonePrices AS
(
	SELECT P.ProductId
		, P.ProductGuid
		, P.GersSku
		, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag WHERE ProductGuid = P.ProductGuid AND Tag = 'prepaid'), 0)) AS IsPrepaid
		, (SELECT TOP 1 Price FROM catalog.GersPrice WHERE GersSku = P.GersSku AND PriceGroupCode = 'ECP' AND CONVERT(date, CONVERT(VARCHAR(50), StartDate, 101)) <= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) AND CONVERT(date, CONVERT(VARCHAR(50), EndDate, 101)) >= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) ORDER BY StartDate DESC) AS ECP
		, (SELECT TOP 1 Price FROM catalog.GersPrice WHERE GersSku = P.GersSku AND PriceGroupCode = 'ECN' AND CONVERT(date, CONVERT(VARCHAR(50), StartDate, 101)) <= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) AND CONVERT(date, CONVERT(VARCHAR(50), EndDate, 101)) >= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) ORDER BY StartDate DESC) AS ECN
		, (SELECT TOP 1 Price FROM catalog.GersPrice WHERE GersSku = P.GersSku AND PriceGroupCode = 'ECU' AND CONVERT(date, CONVERT(VARCHAR(50), StartDate, 101)) <= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) AND CONVERT(date, CONVERT(VARCHAR(50), EndDate, 101)) >= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) ORDER BY StartDate DESC) AS ECU
		, (SELECT TOP 1 Price FROM catalog.GersPrice WHERE GersSku = P.GersSku AND PriceGroupCode = 'ECA' AND CONVERT(date, CONVERT(VARCHAR(50), StartDate, 101)) <= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) AND CONVERT(date, CONVERT(VARCHAR(50), EndDate, 101)) >= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) ORDER BY StartDate DESC) AS ECA
		, (SELECT TOP 1 Price FROM catalog.GersPrice WHERE GersSku = P.GersSku AND PriceGroupCode = 'COG' AND CONVERT(date, CONVERT(VARCHAR(50), StartDate, 101)) <= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) AND CONVERT(date, CONVERT(VARCHAR(50), EndDate, 101)) >= CONVERT(date, CONVERT(VARCHAR(50), GETDATE(), 101)) ORDER BY StartDate DESC) AS COG

	FROM catalog.Product P
		INNER JOIN catalog.Device D ON P.ProductGuid = D.DeviceGuid AND P.GersSku IS NOT NULL
)
, MissingPrices AS
(
	SELECT ProductId
		, ProductGuid
		, GersSku
		, CASE WHEN ECP IS NULL OR ECN IS NULL 
		--OR COG IS NULL 
		OR (IsPrepaid = 0 AND (ECU IS NULL OR ECA IS NULL)) THEN 1 ELSE 0 END AS IsMissingPrice
	FROM PhonePrices
)
, NewAutoHideTags AS
(
	SELECT P.ProductGuid, 'autohide' AS Tag, P.ProductId, P.GersSku, P.Active
	FROM catalog.Product AS P
		INNER JOIN catalog.Device AS D ON P.ProductGuid = D.DeviceGuid AND P.GersSku IS NOT NULL
		INNER JOIN catalog.Inventory AS I ON P.GersSku = I.GersSku AND i.Active = 1
		LEFT OUTER JOIN catalog.ProductTag PT ON P.ProductGuid = PT.ProductGuid AND PT.Tag = 'hide'
		LEFT OUTER JOIN MissingPrices MP on P.ProductGuid = MP.ProductGuid
	WHERE P.Active = 1 AND PT.Tag IS NULL AND (I.AvailableQty <= 0 OR ISNULL(MP.IsMissingPrice, 1) = 1)
)

MERGE ExistingAutoHideTags AS Trg
USING NewAutoHideTags AS Src
ON Trg.ProductGuid = Src.ProductGuid AND Trg.Tag = Src.Tag
WHEN NOT MATCHED BY SOURCE THEN
	DELETE
WHEN NOT MATCHED BY TARGET THEN
	INSERT VALUES (Src.ProductGuid, Src.Tag)
--OUTPUT $action, inserted.*, deleted.*
;

COMMIT;