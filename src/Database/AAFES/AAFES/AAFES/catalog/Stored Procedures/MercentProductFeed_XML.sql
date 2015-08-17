CREATE PROC catalog.MercentProductFeed_XML
AS
DECLARE @XmlOutput xml 
SET @XmlOutput = (select * from catalog.vw_MercentProductFeed
FOR XML AUTO, ROOT('Products'), ELEMENTS)

SELECT @XmlOutput