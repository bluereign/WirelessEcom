CREATE VIEW service.WeblinkAddCommissionSkuUnion AS

SELECT ProductId, GersSku FROM service.WeblinkAdditionalCommissionSkus

UNION ALL

SELECT P.ProductId, 'CWSTMOPRE' AS GersSku
FROM catalog.Product P
	INNER JOIN catalog.Device D
		ON P.ProductGuid = D.DeviceGuid
	INNER JOIN catalog.Company C
		ON D.CarrierGuid = C.CompanyGuid AND C.IsCarrier = 1 AND C.CompanyName = 'T-Mobile'
	INNER JOIN catalog.ProductTag PT
		ON P.ProductGuid = PT.ProductGuid AND PT.Tag = 'prepaid'