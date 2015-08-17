SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [cartoys].[Images] AS



WITH DEVICES AS
(
                SELECT DeviceGuid, UPC, Carrier FROM cartoys.Device

                UNION ALL

                SELECT PPC.ParentProductGuid AS DeviceGuid, D.UPC, D.Carrier
                FROM cartoys.Device D
                                INNER JOIN catalog.ProducttoParentChannel PPC ON D.DeviceGuid = PPC.ProductGuid
                                WHERE ppc.ChannelId = '4'
),
ParentGuid (ProductId, ProductGuid, ParentProductGuid, GersSku, Active, ChannelId) AS (
SELECT DISTINCT
	p.ProductId
	,p.ProductGuid
	,ppc.ParentProductGuid
	,p.GersSku
	,p.Active
	,p.ChannelID
FROM
	catalog.Product p
INNER JOIN catalog.ProducttoParentChannel ppc ON ppc.ProductGuid = p.ProductGuid
WHERE p.ChannelID = '4')



SELECT D.Carrier
                , D.UPC AS CarrierDeviceCode
                , D.UPC + N'_'+ CONVERT(nvarchar(40), I.ImageGuid) + N'.jpg' AS ImageFileName
                , CONVERT(tinyint, I.IsPrimaryImage) AS IsPrimaryImage --fix SSIS conversion warning **
                , I.Title
                , I.Caption
                , I.Alt
                , I.OriginalHeight
                , I.OriginalWidth
                , I.CreatedDate
                , I.CreatedBy
                , I.Ordinal
                , I.binImage
FROM DEVICES D
                INNER JOIN catalog.[Image] I ON D.DeviceGuid = I.ReferenceGuid AND I.IsActive = 1


/*


WITH DEVICES AS
(
       SELECT DeviceGuid, UPC, Carrier FROM cartoys.Device

       UNION ALL

       SELECT PPC.ParentProductGuid AS DeviceGuid, D.UPC, D.Carrier
       FROM cartoys.Device D
              INNER JOIN catalog.ProducttoParentChannel PPC ON D.DeviceGuid = PPC.ProductGuid
)
SELECT D.Carrier
       , D.UPC AS CarrierDeviceCode
       , D.UPC + N'_'+ CONVERT(nvarchar(40), I.ImageGuid) + N'.jpg' AS ImageFileName
       , CONVERT(tinyint, I.IsPrimaryImage) AS IsPrimaryImage --fix SSIS conversion warning **
       , I.Title
       , I.Caption
       , I.Alt
       , I.OriginalHeight
       , I.OriginalWidth
       , I.CreatedDate
       , I.CreatedBy
       , I.Ordinal
       , I.binImage
FROM DEVICES D
       INNER JOIN catalog.[Image] I ON D.DeviceGuid = I.ReferenceGuid AND I.IsActive = 1

*/




GO
