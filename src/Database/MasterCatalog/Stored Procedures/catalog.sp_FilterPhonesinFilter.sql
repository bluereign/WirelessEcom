SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Naomi Hall
-- Create date: 01/07/2014
-- Description:	provide filter management
-- =============================================

CREATE PROCEDURE [catalog].[sp_FilterPhonesinFilter]
(

@FilterId int -- ID of filter

)
AS


BEGIN
	SET NOCOUNT ON;




DECLARE @DynamicTag NVARCHAR(4000)
SELECT @DynamicTag = DynamicTag
FROM catalog.FilterOption WHERE FilterOptionId = @FilterId

DECLARE  @t TABLE
(
a uniqueidentifier
)
INSERT INTO @t (a)
EXECUTE sp_executesql
    @DynamicTag

SELECT GersSku AS 'SKUs in Filter', cc.CompanyName AS 'Carrier', ISNULL(cpy.Value,'[Uses Master Title]') AS 'Title', cp.Active, CASE cp.ChannelID WHEN '2' THEN 'Costco' WHEN '3' THEN 'AAFES' WHEN '4' THEN 'CARTOYS' WHEN '1' THEN 'MASTER' ELSE 'Unassigned' END AS 'Channel'
FROM catalog.Product cp
INNER JOIN @t t ON t.a = cp.ProductGuid
INNER JOIN catalog.Device cd ON cd.DeviceGuid = cp.ProductGuid
INNER JOIN catalog.Company cc ON cc.CompanyGuid = cd.CarrierGuid
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = cp.ProductGuid AND cpy.Name = 'Title'
UNION 
SELECT GersSku AS 'SKUs in Filter', cc.CompanyName AS 'Carrier', ISNULL(cpy.Value,'[Uses Master Title]') AS 'Title', cp.Active, CASE cp.ChannelID WHEN '2' THEN 'Costco' WHEN '3' THEN 'AAFES' WHEN '4' THEN 'CARTOYS' WHEN '1' THEN 'MASTER' ELSE 'Unassigned' END AS 'Channel'
FROM @t t
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ParentProductGuid = t.a
INNER JOIN catalog.Product cp ON cp.ProductGuid = ppc.ProductGuid
INNER JOIN catalog.Device cd ON cd.DeviceGuid = cp.ProductGuid
INNER JOIN catalog.Company cc ON cc.CompanyGuid = cd.CarrierGuid
LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = ppc.ProductGuid AND cpy.Name = 'Title'
ORDER BY [Channel] DESC



	SET NOCOUNT OFF 
END




GO
GRANT EXECUTE ON  [catalog].[sp_FilterPhonesinFilter] TO [managefilter]
GO
