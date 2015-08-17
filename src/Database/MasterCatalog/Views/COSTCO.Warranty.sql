
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/* Push Static Data to catalog.Warranty */

CREATE VIEW [COSTCO].[Warranty] AS

WITH ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '2')

SELECT
	pr.ProductGuid AS 'WarrantyGuid'
	,w.CarrierId
	,CASE WHEN w.UPC <> p.UPC THEN p.UPC ELSE w.UPC END AS 'UPC'
	,w.Title
	,w.Description
	,w.ContractTerm
	,CASE WHEN w.Price <> p.Price THEN p.Price ELSE w.Price END AS 'Price'
	,CASE WHEN w.Deductible <> p.deductible THEN p.deductible ELSE w.deductible END AS 'Deductible'
	,w.MonthlyFee
	,w.AdditionalDevicePrice
	,w.AdditionalDeviceDeductible
	,w.AdditionalDeviceMonthlyFee
	,w.CompanyGuid
FROM
	catalog.Warranty w
INNER JOIN ParentGuid pr ON pr.ParentProductGuid = w.WarrantyGuid
LEFT JOIN catalog.warranty p ON p.WarrantyGuid = pr.ProductGuid



GO
