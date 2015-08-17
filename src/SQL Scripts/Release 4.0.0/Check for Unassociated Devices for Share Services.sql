DECLARE @ATTActiveSkers TABLE
(GersSku VARCHAR(9)
,ProductGuid uniqueidentifier
,Carrier NVARCHAR(30)
,SDF NVARCHAR(12)
,ServiceName NVARCHAR(100)
)

INSERT INTO @ATTActiveSkers (GersSku, ProductGuid, Carrier)
SELECT cp.GersSku, cp.ProductGuid, cc.CompanyName
FROM catalog.Product cp
INNER JOIN catalog.device cd ON cd.deviceguid = cp.productguid
INNER JOIN catalog.company cc ON cc.companyguid = cd.carrierguid
WHERE cc.companyname LIKE '%at&t%' AND cp.Active = '1'

DECLARE @ATTPart2Skers TABLE
(Skers VARCHAR(9)
,SDF NVARCHAR(12)
,ServiceName NVARCHAR(100)
)

INSERT INTO @ATTPart2Skers (Skers, SDF, ServiceName)
SELECT
	aas.gerssku
	,cs.carrierbillcode
	,cs.Title
FROM @ATTActiveSkers aas
LEFT OUTER JOIN catalog.DeviceService cds ON cds.deviceguid = aas.productguid
LEFT OUTER JOIN catalog.Service cs ON cs.serviceguid = cds.serviceguid
WHERE
cs.carrierbillcode IN (
'SDFSL45', -- LTE 1GBS
'SDFSL40', -- LTE 4GBS
'SDFSL35', -- LTE 6GBS
'SDFSL30', -- LTE 10GBS, 15GBS, 20GBS
'SDFSM45N', -- 3G/4G 1GBS
'SDFSM40N', -- 3G/4G 4GBS
'SDFSM35N', -- 3G/4G 6GBS
'SDFSM30N', -- 3G/4G 10GBS, 15GBS, 20GBS
'SDFBB45', -- BERRY 1GBS
'SDFBB40', -- BERRY 4GBS
'SDFBB35', -- BERRY 6GBS
'SDFBB30', -- BERRY 10GBS, 15GBS, 20GBS
'SDFP30', -- FEATURE 1GBS THRU 20GBS
'SDPDCLTCC' -- DATA SERVICE
)

SELECT
	aas.Carrier
	,aas.GersSku
	,aa2.SDF
	,aa2.ServiceName
FROM @ATTActiveSkers aas
LEFT OUTER JOIN @ATTPart2Skers aa2 ON aa2.Skers = aas.GersSku
ORDER BY aas.GersSku
