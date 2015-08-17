CREATE PROC [orders].[sp_GetCarrierResponseRefs]
	@LookupData varchar(50),
	@LookupDate datetime = null
  as
    IF (@LookupDate IS NULL) BEGIN set @LookupDate = GetDate() END
    SELECT DISTINCT LoggedDateTime, ReferenceNumber, Carrier, RequestType as Type
	FROM  [CARTOYS].[service].[CarrierInterfaceLog] with (nolock)
    WHERE LoggedDateTime > @LookupDate AND Data like '%' + @LookupData + '%' and Type = 'Request'