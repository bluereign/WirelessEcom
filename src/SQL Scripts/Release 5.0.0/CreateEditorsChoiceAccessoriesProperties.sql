DELETE FROM catalog.Property

WHERE Name = 'sort.EditorsChoiceAccessories'

DECLARE @Rank1 VARCHAR(10) = 'MV9MCPC2'
DECLARE @Rank2 VARCHAR(10) = '7727604'
DECLARE @Rank3 VARCHAR(10) = '7721392A'
DECLARE @Rank4 VARCHAR(10) = 'U3N1WA2'
DECLARE @Rank5 VARCHAR(10) = 'ENERGI2T'
DECLARE @Rank6 VARCHAR(10) = 'CIPHW9'
DECLARE @Rank7 VARCHAR(10) = 'GOGOJUGRN'
 

INSERT INTO catalog.Property (ProductGuid, Value, Name, LastModifiedDate, LastModifiedBy, IsCustom, Active)

VALUES

      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank1), 1, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank2), 2, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank3), 3, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),     
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank4), 4, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank5), 5, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank6), 6, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1),
      ((SELECT ProductGuid FROM catalog.Product WHERE GersSku = @Rank7), 7, 'sort.EditorsChoiceAccessories', GETDATE(), 'dynamic', 1, 1)
 
SELECT p.GersSku, *
FROM catalog.Property pp
INNER JOIN catalog.Product p ON p.ProductGuid = pp.ProductGuid
WHERE Name = 'sort.EditorsChoiceAccessories'
ORDER BY CONVERT(int, Value);

GO