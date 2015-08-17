

CREATE VIEW [catalog].[vProductRebates] WITH SCHEMABINDING AS
select
	p.ProductId,
	rtp.ProductGuid,
	rtp.RebateGuid,
	rtp.RebateMode,
	rtp.StartDate,
	rtp.EndDate,
	r.Title,
	r.Amount,
	r.Active,
	r.URL
from catalog.Product p
	INNER JOIN catalog.RebateToProduct rtp
		ON p.ProductGuid = rtp.ProductGuid
		AND GETDATE() >= rtp.StartDate
		AND GETDATE() <= rtp.EndDate
	INNER JOIN catalog.Rebate r
		ON rtp.RebateGuid = r.RebateGuid
		AND r.Active = 1