
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* Push Static Data to catalog.Rateplan */

CREATE VIEW [AAFES].[Rateplan] AS

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
WHERE p.ChannelID = '3')


SELECT DISTINCT
	pp.ProductGuid AS 'RateplanGuid'
	,r.CarrierGuid
	,r.CarrierBillCode
	,r.Title
	,r.Description
	,r.Type
	,r.ContractTerm
	,r.IncludedLines
	,r.MaxLines
	,CASE WHEN r.MonthlyFee <> (SELECT MonthlyFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) THEN (SELECT MonthlyFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) ELSE r.MonthlyFee END AS 'MonthlyFee'
	,r.AdditionalLineBillCode
	,CASE WHEN r.AdditionalLineFee <> (SELECT AdditionalLineFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) THEN (SELECT AdditionalLineFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) ELSE r.AdditionalLineFee END AS 'AdditionalLineFee'
	,CASE WHEN r.PrimaryActivationFee <> (SELECT PrimaryActivationFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) THEN (SELECT PrimaryActivationFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) ELSE r.PrimaryActivationFee END AS 'PrimaryActivationFee'
	,CASE WHEN r.SecondaryActivationFee <> (SELECT SecondaryActivationFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) THEN (SELECT SecondaryActivationFee FROM catalog.Rateplan WHERE RateplanGuid = pp.ProductGuid) ELSE r.SecondaryActivationFee END AS 'SecondaryActivationFee'
	,r.IsShared
FROM
	catalog.Rateplan r
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = r.RateplanGuid
INNER JOIN ParentGuid pp ON pp.ProductGuid = ppc.ProductGuid
WHERE pp.ChannelId = '3'




GO
