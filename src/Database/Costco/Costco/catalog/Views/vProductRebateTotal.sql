

CREATE VIEW [catalog].[vProductRebateTotal] WITH SCHEMABINDING AS
select
	p.ProductGuid,
	p.ProductId,
	rtp.RebateMode,
	ISNULL(SUM(r.Amount),0) as RebateTotal
from catalog.Product p
	INNER JOIN catalog.RebateToProduct rtp
		ON p.ProductGuid = rtp.ProductGuid
		AND GETDATE() >= rtp.StartDate
		AND GETDATE() <= rtp.EndDate
	INNER JOIN catalog.Rebate r
		ON rtp.RebateGuid = r.RebateGuid
		AND r.Active = 1
group by
	p.ProductGuid,
	p.ProductId,
	rtp.RebateMode