

CREATE VIEW [test].[FreeAccessories]
AS
SELECT     Pd.ProductId, Pd.GersSku, Pa.ProductId AS AccessoryProductId, Pa.GersSku AS AccessoryGersSku, A.UPC,CASE RTRIM(ISNULL((SELECT PROP.Value FROM catalog.Property PROP WHERE PROP.ProductGuid = A.AccessoryGuid AND PROP.Name='title'),'')) WHEN '' THEN A.Name ELSE RTRIM((SELECT PROP.Value FROM catalog.Property PROP WHERE PROP.ProductGuid = A.AccessoryGuid AND PROP.Name='title')) END AS Title
FROM         catalog.Product AS Pd INNER JOIN
                      catalog.DeviceFreeAccessory AS DFA ON Pd.ProductGuid = DFA.DeviceGuid INNER JOIN
                      catalog.Product AS Pa ON DFA.ProductGuid = Pa.ProductGuid INNER JOIN
                      catalog.Accessory AS A ON Pa.ProductGuid = A.AccessoryGuid