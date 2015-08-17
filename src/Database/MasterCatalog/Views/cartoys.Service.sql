
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [cartoys].[Service] AS 

----- Service Information
SELECT
	r.CarrierBillCode
	,cpy.Label AS 'CleanName'
	,cc1.CompanyName AS 'Carrier'
	,r.MonthlyFee
	,r.CartTypeId
	,CASE cpy2.Value
	WHEN ''
	THEN
	(SELECT cpyy.Value FROM catalog.Property cpyy INNER JOIN catalog.Product cpp ON cpp.ProductGuid = cpyy.ProductGuid AND cpp.ChannelID = '3'
	WHERE cpyy.ProductGuid = r.ServiceGuid AND cpyy.Name = 'shortdescription')
	ELSE cpy2.Value END AS 'ShortDescription'
	,cpy3.Value AS 'LongDescription'
FROM catalog.service r 
INNER JOIN catalog.Product cp ON cp.ProductGuid = r.ServiceGuid AND cp.ChannelID = '1'
INNER JOIN catalog.ServiceMaster cpy ON cpy.ServiceGUID = r.ServiceGuid
INNER JOIN catalog.Company cc1 ON cc1.CompanyGuid = r.CarrierGuid AND IsCarrier = '1'
INNER JOIN catalog.Property cpy2 ON cpy2.ProductGuid = r.ServiceGuid AND cpy2.Name = 'shortdescription'
INNER JOIN catalog.Property cpy3 ON cpy3.ProductGuid = r.ServiceGuid AND cpy3.Name = 'longdescription'
WHERE r.CarrierGuid = '83D7A62E-E62F-4E37-A421-3D5711182FB0'
AND cp.Active = '1'



GO
