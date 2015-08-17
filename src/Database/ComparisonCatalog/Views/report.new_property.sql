SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [report].[new_property]
AS
SELECT ProductCode, ProductType, Name, Value FROM catalogthisweek.property cdt WHERE NOT EXISTS (SELECT ProductCode, ProductType, Name, Value  FROM cataloglastweek.property cdl WHERE cdt.ProductCode = cdl.ProductCode AND cdt.Name = cdl.Name)

GO
