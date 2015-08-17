/*

CREATE FUNCTION [dbo].[GetPINFromXML] (@referenceNumber varchar(30))  
RETURNS varchar(30) AS  
BEGIN 

DECLARE @requestXml AS XML 
DECLARE @pin VARCHAR(30)
DECLARE @carrier VARCHAR(30)

SELECT TOP 1 @carrier = carrier 
FROM service.CarrierInterfaceLog 
WHERE referenceNumber = @referenceNumber 
ORDER BY loggedDateTime DESC

IF @carrier = 'Att'
BEGIN
	-- get the record containing the mdn and pin
	SELECT	TOP 1 @requestXML = [DATA] 
	FROM	service.CarrierInterfaceLog 
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'CustomerLookupByMdn'
	AND		Carrier = @carrier
	AND		[Type] = 'Request'
	ORDER BY  id DESC
	
	-- query for the mdn
	SELECT @pin = CAST(@requestXml .query('declare namespace ns1="http://www.w3.org/2001/XMLSchema-instance";
	declare namespace ns2="http://www.w3.org/2001/XMLSchema";	
	declare namespace ns3="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileRequest.xsd"; 
	declare namespace ns4="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd"; 
	data(/InquireAccountProfileRequestInfo/ns3:AccountVerification/ns4:last4SSN)') AS VARCHAR(30))

END	

IF @carrier = 'TMobile'
BEGIN 
	-- get the record containing the mdn and pin
	SELECT	TOP 1 @requestXML = [DATA] 
	FROM	service.CarrierInterfaceLog 
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'ServiceCustomerLookup'
	AND		Carrier = @carrier
	AND		[Type] = 'Request'
	ORDER BY  id DESC

	-- query for the mdn
	SELECT @pin = CAST(@requestXml.query('declare namespace TMO="http://retail.tmobile.com/sdo";
	declare namespace TMO2="http://www.w3.org/2001/XMLSchema-instance"; 
	declare namespace TMO3="http://www.w3.org/2001/XMLSchema"; 
	data(/CustomerLookupByMSISDNRequest/TMO:pin)') AS VARCHAR(30))
END

return @pin
END*/



