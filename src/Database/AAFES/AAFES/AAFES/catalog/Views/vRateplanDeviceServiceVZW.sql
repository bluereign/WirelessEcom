





CREATE VIEW [catalog].[vRateplanDeviceServiceVZW] AS
-- Verizon Rateplan Included Services
SELECT     R.RateplanGuid, D.DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Company AS C INNER JOIN
                      catalog.Service AS S ON C.CompanyName = N'Verizon Wireless' AND C.CompanyGuid = S.CarrierGuid INNER JOIN
                      catalog.RateplanService AS RS ON S.ServiceGuid = RS.ServiceGuid INNER JOIN
                      catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.Device AS D ON RD.DeviceGuid = D.DeviceGuid ON RS.RateplanGuid = R.RateplanGuid
WHERE     (RS.IsIncluded = 1)

UNION ALL

-- Verizon Rateplan Optional Services (NULL Device)
SELECT     R.RateplanGuid, NULL AS DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, NULL AS UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Company AS C INNER JOIN
                      catalog.Service AS S ON C.CompanyName = N'Verizon Wireless' AND C.CompanyGuid = S.CarrierGuid INNER JOIN
                      catalog.RateplanService AS RS ON S.ServiceGuid = RS.ServiceGuid INNER JOIN
                      catalog.Rateplan AS R ON RS.RateplanGuid = R.RateplanGuid
WHERE     (RS.IsIncluded = 0)

UNION ALL

-- Verizon Device Services (NULL Rateplan)
SELECT     NULL AS RateplanGuid, D.DeviceGuid, S.ServiceGuid, NULL AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, CONVERT(bit, 0) AS IsIncluded
FROM         catalog.Device AS D INNER JOIN
                      catalog.DeviceService AS DS ON D.DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON C.CompanyName = N'Verizon Wireless' AND S.CarrierGuid = C.CompanyGuid

UNION ALL

-- Verizon Rateplan/Device Services (Rateplan and Device defined)
SELECT     R.RateplanGuid, D.DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.Device AS D ON RD.DeviceGuid = D.DeviceGuid INNER JOIN
                      catalog.DeviceService AS DS ON D.DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON C.CompanyName = N'Verizon Wireless' AND S.CarrierGuid = C.CompanyGuid INNER JOIN
                      catalog.RateplanService AS RS ON R.RateplanGuid = RS.RateplanGuid AND S.ServiceGuid = RS.ServiceGuid
WHERE     (RS.IsIncluded = 0)

UNION ALL

SELECT     R.RateplanGuid, D.DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.dn_Tablets AS D ON RD.DeviceGuid = D.DeviceGuid INNER JOIN
                      catalog.DeviceService AS DS ON D.DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON C.CompanyName = N'Verizon Wireless' AND S.CarrierGuid = C.CompanyGuid INNER JOIN
                      catalog.RateplanService AS RS ON R.RateplanGuid = RS.RateplanGuid AND S.ServiceGuid = RS.ServiceGuid
WHERE     (RS.IsIncluded = 0)

UNION ALL

SELECT     R.RateplanGuid, D.DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Company AS C INNER JOIN
                      catalog.Service AS S ON C.CompanyName = N'Verizon Wireless' AND C.CompanyGuid = S.CarrierGuid INNER JOIN
                      catalog.RateplanService AS RS ON S.ServiceGuid = RS.ServiceGuid INNER JOIN
                      catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.dn_tablets AS D ON RD.DeviceGuid = D.DeviceGuid ON RS.RateplanGuid = R.RateplanGuid
WHERE     (RS.IsIncluded = 1)

UNION ALL 

SELECT     NULL AS RateplanGuid, D.DeviceGuid, S.ServiceGuid, NULL AS RateplanBillCode, D.UPC, S.CarrierGuid, C.CompanyName AS CarrierName, 
                      S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, CONVERT(bit, 0) AS IsIncluded
FROM         catalog.dn_tablets AS D INNER JOIN
                      catalog.DeviceService AS DS ON D.DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON C.CompanyName = N'Verizon Wireless' AND S.CarrierGuid = C.CompanyGuid