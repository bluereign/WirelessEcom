CREATE VIEW report.HandsetPriceHistory
AS
SELECT     GersSku, PriceGroupCode, Price, StartDate, EndDate
FROM         catalog.GersPrice
WHERE     (PriceGroupCode LIKE 'EC_')