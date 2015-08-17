<h1>Test Page</h1>

<cfscript>
	request.layoutFile = 'nolayout';
	request.bodycontent = '';
	request.config.CarrierServiceBus.Endpoint = 'https://uat-services.wirelessadvocates.com/ServiceBus/json/syncreply';
	
	requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
	requestHeader.setServiceAreaZip( 98121 );
	requestHeader.setReferenceNumber( 'TEST12345' );

	//application.model.Util.cfdump( requestHeader);
	
	
	
	//application.model.Util.cfdump( request.config.CarrierServiceBus ); 
	WriteOutput("<hr />");
	//application.model.Util.cfabort();
	
	npaNxxRequest = CreateObject('component', 'cfc.model.carrierservice.Att.NpaNxxRequest').init();
	npaNxxRequest.setRequestHeader( requestHeader );
	npaNxxRequest.setZipCode( 98121 );
	npaNxxRequest.setMethod( 'ZIP' ); //TODO: find out what value is expected
	
	serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
	serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
	serviceBusRequest.setAction( 'NpaNxxLookup' );
	serviceBusRequest.setRequestData( npaNxxRequest );
	
	
	application.model.Util.cfdump( serviceBusRequest.toJson() );
	WriteOutput("<hr />");
	
	xxxRouteService = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.RouteService').init( argumentCollection = request.config.CarrierServiceBus );
	
	serviceBusReponse = xxxRouteService.Route( serviceBusRequest );
	
	if ( structKeyExists(serviceBusReponse, 'RESPONSESTATUS.ERRORCODE') && serviceBusReponse.ResponseStatus.ErrorCode eq 0)
	{
		application.model.Util.cfdump( serviceBusReponse  );
	}
	else
	{
		application.model.Util.cfdump( serviceBusReponse  );
	}
	
	
</cfscript>