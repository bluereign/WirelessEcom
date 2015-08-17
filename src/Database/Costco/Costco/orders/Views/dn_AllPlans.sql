


CREATE VIEW [orders].[dn_AllPlans]
WITH SCHEMABINDING 
AS
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.RateplanGuid)), r.Title) AS PlanName, c.CompanyName as CarrierName, 
                    r.MonthlyFee AS MonthlyFeex, 'Voice' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Rateplan AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.RateplanGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null                     
UNION
SELECT  DISTINCT    p.ProductId, p.GersSku, ISNULL
	((SELECT     LTRIM(RTRIM(Value)) AS Expr1
    FROM         catalog.Property
    WHERE     (Name = 'catalogProductName') AND (Value <> '') AND (ProductGuid = r.ServiceGuid)), r.Title) AS PlanName,
     c.CompanyName as CarrierName,  r.MonthlyFee AS MonthlyFeex, 'Data' as PlanType, CarrierBillCode, cast( p.ProductGUID as varchar(40)) as ProductGUID
FROM         catalog.Service AS r INNER JOIN
                      catalog.Company AS c ON r.CarrierGuid = c.CompanyGuid LEFT JOIN
                      catalog.Product AS p ON r.ServiceGuid = p.ProductGuid
WHERE (p.Active = 1) and p.GersSku is not null