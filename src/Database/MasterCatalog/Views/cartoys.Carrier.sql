SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [cartoys].[Carrier] AS

SELECT C.CompanyName AS CarrierName
FROM catalog.Company C WHERE IsCarrier = 1


GO
