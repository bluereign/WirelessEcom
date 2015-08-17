CREATE FUNCTION [ups].[udf_GetMilitaryBaseCode] (@MilitaryBase nvarchar(100))
RETURNS nvarchar(100)
AS
BEGIN RETURN (
SELECT ISNULL(CONVERT(varchar(10),StoreCode) + ' SHIP BASE = ' + BaseName + ' ' + CONVERT(varchar(10),KioskCode),'SHIP BASE = ' + BaseName)
FROM ups.militarybase
WHERE BaseName = @MilitaryBase
)
END