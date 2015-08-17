CREATE view [orders].[dn_AllServices]
as
SELECT       cast(s.ServiceGuid as varchar(40)) as ServiceGuid ,  C.CompanyName AS CarrierName, 
                     S.Title as ServiceName, S.MonthlyFee,
                      cast(r.RatePlanGuid as varchar(40)) as RatePlanGUID, p.ProductID
                       
FROM         catalog.Device AS D INNER JOIN
                      catalog.DeviceService AS DS ON D.DeviceGuid = DS.DeviceGuid INNER JOIN
                      catalog.Service AS S ON DS.ServiceGuid = S.ServiceGuid INNER JOIN
                      catalog.Product as P on p.ProductGuid = s.ServiceGuid inner join
                      catalog.Company AS C ON S.CarrierGuid = C.CompanyGuid INNER JOIN
                      catalog.RateplanDevice AS RD ON D.DeviceGuid = RD.DeviceGuid INNER JOIN                    
                      catalog.Rateplan AS R ON RD.RateplanGuid = R.RateplanGuid LEFT OUTER JOIN
                          (SELECT DISTINCT ServiceGuid
                            FROM          catalog.RateplanService AS RS1
                            WHERE      (IsIncluded = 0)) AS RS ON S.ServiceGuid = RS.ServiceGuid
WHERE     (RS.ServiceGuid IS NULL)