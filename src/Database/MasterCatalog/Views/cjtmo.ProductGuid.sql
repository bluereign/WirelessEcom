SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW cjtmo.ProductGuid AS
SELECT ProductGuid,'1' AS 'ProductTypeId' FROM cjtmo.product
GO
