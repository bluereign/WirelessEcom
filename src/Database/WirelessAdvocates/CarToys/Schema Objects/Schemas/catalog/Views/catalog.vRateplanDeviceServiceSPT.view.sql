
create view [catalog].[vRateplanDeviceServiceSPT] as 

/* Sprint Device Services*/ SELECT R.RateplanGuid, D .DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D .UPC, S.CarrierGuid, 
                      C.CompanyName AS CarrierName, S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, CONVERT(bit, 0) AS IsIncluded
FROM         catalog.Device AS D INNER JOIN
                      catalog.DeviceService AS DS ON D .DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON S.CarrierGuid = C.CompanyGuid INNER JOIN
                      catalog.RateplanDevice AS RD ON D .DeviceGuid = RD.DeviceGuid INNER JOIN
                      catalog.Rateplan AS R ON RD.RateplanGuid = R.RateplanGuid LEFT OUTER JOIN
                          (SELECT DISTINCT ServiceGuid
                            FROM          catalog.RateplanService AS RS1
                            WHERE      (IsIncluded = 0)) AS RS ON S.ServiceGuid = RS.ServiceGuid
WHERE     (C.CompanyName = N'Sprint') AND (RS.ServiceGuid IS NULL)
UNION ALL
/* SprintRateplanDevice Services*/ SELECT R.RateplanGuid, D .DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D .UPC, S.CarrierGuid, 
                      C.CompanyName AS CarrierName, S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.Device AS D ON RD.DeviceGuid = D .DeviceGuid INNER JOIN
                      catalog.DeviceService AS DS ON D .DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Company AS C ON S.CarrierGuid = C.CompanyGuid INNER JOIN
                      catalog.RateplanService AS RS ON R.RateplanGuid = RS.RateplanGuid AND S.ServiceGuid = RS.ServiceGuid
WHERE     (C.CompanyName = N'Sprint') AND (RS.IsIncluded = 0)
UNION ALL
/* Sprint Rateplan Services (Included)*/ SELECT R.RateplanGuid, D .DeviceGuid, S.ServiceGuid, R.CarrierBillCode AS RateplanBillCode, D .UPC, S.CarrierGuid, 
                      C.CompanyName AS CarrierName, S.CarrierBillCode AS ServiceBillCode, S.Title, S.MonthlyFee, RS.IsIncluded
FROM         catalog.Company AS C INNER JOIN
                      catalog.Service AS S ON C.CompanyGuid = S.CarrierGuid INNER JOIN
                      catalog.RateplanService AS RS ON S.ServiceGuid = RS.ServiceGuid INNER JOIN
                      catalog.Rateplan AS R INNER JOIN
                      catalog.RateplanDevice AS RD ON R.RateplanGuid = RD.RateplanGuid INNER JOIN
                      catalog.Device AS D ON RD.DeviceGuid = D .DeviceGuid ON RS.RateplanGuid = R.RateplanGuid
WHERE     (C.CompanyName = N'Sprint') AND (RS.IsIncluded = 1)
