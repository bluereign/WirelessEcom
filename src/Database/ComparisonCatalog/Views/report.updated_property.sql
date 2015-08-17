SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [report].[updated_property]
AS
SELECT DISTINCT 'New' AS 'Updated', cdt.ProductCode, cdt.ProductType, cdt.Name, cdt.Value FROM catalogthisweek.property cdt
INNER JOIN cataloglastweek.property cdl ON cdl.ProductCode = cdt.ProductCode AND cdl.ProductType = cdt.ProductType AND cdl.Name = cdt.Name
WHERE cdt.Value <> cdl.Value

UNION

SELECT DISTINCT 'Previous' AS 'Updated', cdt.ProductCode, cdt.ProductType, cdt.Name, cdt.Value FROM cataloglastweek.property cdt
INNER JOIN catalogthisweek.property cdl ON cdl.ProductCode = cdt.ProductCode AND cdl.ProductType = cdt.ProductType AND cdl.Name = cdt.Name
WHERE cdt.Value <> cdl.Value
GO
