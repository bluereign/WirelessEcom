--for ATT

-- Fixing Product ID 4020 3G/4G Associations
SELECT cp.productid, cp.GersSku, cs.title, cds.*
FROM CATALOG.PRODUCT CP
INNER JOIN CATALOG.DEVICESERVICE CDS ON CDS.DEVICEGUID = CP.PRODUCTGUID
inner join catalog.Service cs ON cs.ServiceGuid = cds.ServiceGuid
where cp.productid in ('4020', '4876') and cs.title LIKE '%data%'

DELETE FROM catalog.DeviceService
WHERE DeviceGuid = '7F5007F6-06AF-60B2-A32F-1A5D1B6366C5' AND ServiceGuid = '36B12D1B-20D3-462B-B70D-08A4CA0E5041'

DELETE FROM catalog.DeviceService
WHERE DeviceGuid = '7F5007F6-06AF-60B2-A32F-1A5D1B6366C5' AND ServiceGuid = '6E11291F-0FD3-4F61-B101-7B831F18C96B'

-- Video Share: Select max of 25 or 60, but not both
USE [TEST.WIRELESSADVOCATES.COM]
UPDATE catalog.ServiceMasterGroup 
SET Type = 'O'
      , MinSelected = 0
      , MaxSelected = 1
WHERE ServiceMasterGroupGuid = '2C24CABD-0F33-4375-8D48-82F7DBE12B84'

-- GPS: Select max of 2 people or max of 5 people, but not both
USE [TEST.WIRELESSADVOCATES.COM]
UPDATE catalog.ServiceMasterGroup 
SET Type = 'O'
      , MinSelected = 0
      , MaxSelected = 1
WHERE ServiceMasterGroupGuid = 'B43CBD74-EE64-43E2-9341-5622A0D5CB0B'


-- Messaging and Data: Force to select a max of 1
USE [TEST.WIRELESSADVOCATES.COM]
UPDATE catalog.ServiceMasterGroup 
SET Type = 'O'
      , MinSelected = 0
      , MaxSelected = 1
WHERE ServiceMasterGroupGuid = '5E519D78-B1FE-458E-B4F7-6AE05C1324F9'

--for TMO

-- Optional Data Services: Force to select a max of 1
USE [TEST.WIRELESSADVOCATES.COM]
UPDATE catalog.ServiceMasterGroup 
SET Type = 'O'
      , MinSelected = 0
      , MaxSelected = 1
WHERE ServiceMasterGroupGuid = '85A6ED7A-C35D-49F6-BDE0-7A620E923409'


-- Messaging: Force to select $5, $10, $20 plan or no thanks
USE [TEST.WIRELESSADVOCATES.COM]
UPDATE catalog.ServiceMasterGroup 
SET Type = 'O'
      , MinSelected = 0
      , MaxSelected = 1
WHERE ServiceMasterGroupGuid = '8033F684-4B7B-44D3-9B59-F5492409D576'


SELECT *
FROM catalog.ServiceMasterGroup
WHERE CARRIERGUID = '83D7A62E-E62F-4E37-A421-3D5711182FB0'
ORDER BY Label

SELECT *
FROM catalog.company

