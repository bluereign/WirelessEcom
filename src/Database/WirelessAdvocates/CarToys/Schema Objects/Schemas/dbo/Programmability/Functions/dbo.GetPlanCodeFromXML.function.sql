/*



--drop function [dbo].[GetMDNFromXML]
CREATE FUNCTION [dbo].[GetPlanCodeFromXML] (@referenceNumber varchar(30))  
RETURNS varchar(30) AS  
BEGIN 

DECLARE @requestXml AS XML 
DECLARE @mdn VARCHAR(30)
DECLARE @carrier VARCHAR(30)


SELECT TOP 1 @carrier = carrier 
FROM service.CarrierInterfaceLog
WHERE referenceNumber = @referenceNumber 


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
	SELECT @mdn = CAST(@requestXml .query('declare namespace ns1="http://www.w3.org/2001/XMLSchema-instance";
	declare namespace ns2="http://www.w3.org/2001/XMLSchema";	
	declare namespace ns3="http://csi.cingular.com/CSI/Namespaces/Container/Public/InquireAccountProfileRequest.xsd"; 
	declare namespace ns4="http://csi.cingular.com/CSI/Namespaces/Types/Public/CingularDataModel.xsd"; 
	data(/InquireAccountProfileRequestInfo/ns3:AccountSelector/ns4:subscriberNumber)') AS VARCHAR(30))

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
	ORDER BY id DESC
	
	-- query for the mdn
	SELECT @mdn = CAST(@requestXml.query('declare namespace TMO="http://retail.tmobile.com/sdo";
	declare namespace TMO2="http://www.w3.org/2001/XMLSchema-instance"; 
	declare namespace TMO3="http://www.w3.org/2001/XMLSchema"; 
	data(/CustomerLookupByMSISDNRequest/TMO:msisdn)') AS VARCHAR(30))
END

SET @carrier = 'Verizon'

IF @carrier = 'Verizon'
BEGIN 
	-- get the record containing the mdn and pin
	SELECT	TOP 1 @requestXML = [DATA] 
	FROM	service.CarrierInterfaceLog
	WHERE	ReferenceNumber = @referenceNumber
	AND		RequestType = 'CustomerLookup'
	AND		Carrier = 'Verizon'
	AND		[Type] = 'Response'
	ORDER BY id DESC
	
	-- query for the mdn
	SELECT @mdn = CAST(@requestXml.query('data(/oasOrderResponse/authenticateSubscriberResponse/lineInformation/planCode)') AS VARCHAR(30))
END
return @mdn
END*/





