<cfcomponent output="false" extends="fw.model.BaseService">

	<cfproperty name="RouteService" inject="id:RouteService" />
		
	<cffunction name="getNpaList" access="public" output="false" returntype="array">
		<cfargument name="ZipCode" type="string" required="true" />
		<cfargument name="CarrierId" type="string" required="true" />
		<cfargument name="ReferenceNumber" type="string" required="true" />
		
		<cfscript>
			var npaList = [];
			
			switch( arguments.CarrierId )
			{
				case '42':
					npaList = getVerizonNpaList( argumentCollection = arguments );
					break;
				default:
					throw('Requested Carrier ID of #arguments.CarriedId# not valid');
					break;
			}
			
			//npaList = ['425', '206', '310'];
		</cfscript>
		
		<cfreturn npaList />
	</cffunction>


	<cffunction name="getCustomerAccount" access="public" output="false" returntype="fw.model.carrier.account.CarrierAccount">
        <cfargument name="CarrierId" type="string" required="true" />
        <cfargument name="Mdn" type="string" required="true" />
        <cfargument name="ZipCode" type="string" required="true" />
        <cfargument name="Pin" type="string" default="" required="false" />
        <cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="AccountPassword" type="string" default="" required="false" />
		<cfargument name="LastFourSsn" type="string" default="" required="false" />
		<cfargument name="SecurityQuestionAnswer" type="string" default="" required="false" />
		<cfargument name="ServiceZipCode" type="string" default="" required="false" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="NumberOfLinesRequested" type="numeric" default="0" required="false" />
		
		<cfscript>
			var customerAccount = '';
			
			switch( arguments.CarrierId )
			{
				case '42':
					customerAccount = getVerizonCustomerAccount( argumentCollection = arguments );
					break;
				case '109':
					customerAccount = getAttCustomerAccount( argumentCollection = arguments );
					break;				
				case '299':
					throw('Requested Carrier ID of #arguments.CarriedId# not valid');
					break;
				default:
					throw('Requested Carrier ID of #arguments.CarriedId# not valid');
					break;
			}
		</cfscript>
		
		<cfreturn customerAccount />
	</cffunction>
	
	
	<!---- Private methods ---->
		
		
	<cffunction name="getVerizonNpaList" access="private" output="false" returntype="array">
		<cfargument name="ZipCode" type="string" required="true" />
		<cfargument name="ReferenceNumber" type="string" required="true" />	
		
		<cfscript>
			var npaList = [];
			var requestHeader = '';
			var npaNxxRequest = '';
			var serviceBusRequest = '';
			var carrierResponse = '';
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
			requestHeader.setServiceAreaZip( arguments.ZipCode );
			requestHeader.setReferenceNumber( arguments.ReferenceNumber );
			
			npaNxxRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.NpaNxxRequest').init();
			npaNxxRequest.setRequestHeader( requestHeader );
			npaNxxRequest.setZipCode( arguments.ZipCode );
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			serviceBusRequest.setAction( 'NpaNxxLookup' );
			serviceBusRequest.setRequestData( npaNxxRequest );
			
			serviceBusReponse = RouteService.Route( serviceBusRequest );
			
			if (serviceBusReponse.ResponseStatus.ErrorCode eq 0)
			{
				carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
				
				//Extract NPA values into an array
				for (i=1; i <= ArrayLen(carrierResponse.NpaSet); i++)
				{
					npaList[i] = carrierResponse.NpaSet[i].NpaNxx;
				}	
			}
			
			npaList = sortNpaList( npaList );
		</cfscript>
		
		<cfreturn npaList />
	</cffunction>

	<cffunction name="getVerizonCustomerAccount" access="private" output="false" returntype="fw.model.carrier.account.CarrierAccount">
        <cfargument name="CarrierId" type="string" required="true" />
        <cfargument name="Mdn" type="string" required="true" />
        <cfargument name="ZipCode" type="string" required="true" />
        <cfargument name="Pin" type="string" default="" required="false" />
        <cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="AccountPassword" type="string" default="" required="false" />
		<cfargument name="LastFourSsn" type="string" default="" required="false" />
		<cfargument name="SecurityQuestionAnswer" type="string" default="" required="false" />
		<cfargument name="ServiceZipCode" type="string" default="" required="false" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="NumberOfLinesRequested" type="numeric" default="0" required="false" />
		
		<cfscript>
			var customerAccount = {};
			var requestHeader = '';
			var customerLookupRequest = '';
			var serviceBusRequest = '';
			var carrierResponse = '';
			var carrierAccount = '';
			var carrierAccountLine = '';
			var accountLines = [];
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
			requestHeader.setServiceAreaZip( arguments.ServiceZipCode );
			requestHeader.setReferenceNumber( arguments.ReferenceNumber );
			
			customerLookupRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CustomerLookupRequest').init();
			customerLookupRequest.setRequestHeader( requestHeader );
			customerLookupRequest.setZipCode( arguments.ZipCode );
			customerLookupRequest.setMdn( arguments.Mdn );
			customerLookupRequest.setSecretKey( arguments.AccountPassword );
			customerLookupRequest.setSSN( arguments.Pin );
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
			serviceBusRequest.setAction( 'CustomerLookup' );
			serviceBusRequest.setRequestData( customerLookupRequest );
			
			serviceBusReponse = RouteService.Route( serviceBusRequest );
			
			switch( serviceBusReponse.ResponseStatus.ErrorCode )
			{
				case '0':
				{
					carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );

					if ( carrierResponse.ResponseStatus.ErrorCode eq '00000')
					{
						//Map successful lookup response to CarrierAccount						
						carrierAccountLine = CreateObject('component', 'fw.model.carrier.account.CarrierAccountLine').init();
						carrierAccount = CreateObject('component', 'fw.model.carrier.account.CarrierAccount').init();
									
						carrierAccountLine.setMdn( carrierResponse.Account.LineInfo.MobileNumber );
						carrierAccountLine.setIsUpgradeEligible( carrierResponse.Account.LineInfo.EligibleForUpgrade );
						
						ArrayAppend( accountLines, carrierAccountLine );
						
						carrierAccount.setAccountNumber( carrierResponse.Account.AccountNumber );
						carrierAccount.setAccountLines( accountLines  );
					
					}
					else if ( carrierResponse.ResponseStatus.ErrorCode eq '00608')
					{
						throw( carrierResponse.ResponseStatus.ErrorCode, carrierResponse.ResponseStatus.Message, 'CustomerNotFound' );
					}					
					else
					{
						throw( carrierResponse.ResponseStatus.ErrorCode, carrierResponse.ResponseStatus.Message, 'RequestExecutionFailure' );
					}

					break;
				}
				case 'RequestExecutionFailure':
					throw( serviceBusReponse.ResponseStatus.Message, serviceBusReponse.ResponseStatus.Message, 'RequestExecutionFailure' );
					break;
				case 'HeaderValidationFailure':
					throw( serviceBusReponse.ResponseStatus.Message, serviceBusReponse.ResponseStatus.Message, 'HeaderValidationFailure' );
					break;
				case 'RequestValidationFailure':
					throw( serviceBusReponse.ResponseStatus.Message, serviceBusReponse.ResponseStatus.Message, 'RequestValidationFailure' );
					break;
				case 'CommunicationFailure':
					throw( serviceBusReponse.ResponseStatus.Message, serviceBusReponse.ResponseStatus.Message, 'CommunicationFailure' );
					break;
				default:
					throw( 'Unknown Error', serviceBusReponse.ResponseStatus.Message, 'UnknownError' );
					break;
			}
		</cfscript>
		
		<cfreturn carrierAccount />
	</cffunction>


	<cffunction name="getAttCustomerAccount" access="private" output="false" returntype="fw.model.carrier.account.CarrierAccount">
        <cfargument name="CarrierId" type="string" required="true" />
        <cfargument name="Mdn" type="string" required="true" />
        <cfargument name="ZipCode" type="string" required="true" />
        <cfargument name="Pin" type="string" default="" required="false" />
        <cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="AccountPassword" type="string" default="" required="false" />
		<cfargument name="LastFourSsn" type="string" default="" required="false" />
		<cfargument name="SecurityQuestionAnswer" type="string" default="" required="false" />
		<cfargument name="ServiceZipCode" type="string" default="" required="false" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="NumberOfLinesRequested" type="numeric" default="0" required="false" />
		
		<cfscript>
			var customerAccount = {};
			var requestHeader = '';
			var customerLookupRequest = '';
			var serviceBusRequest = '';
			var carrierResponse = '';
			var i = 1;
			var carrierAccount = '';
			var carrierAccountLine = '';
			var accountLines = [];
			
			requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
			requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
			requestHeader.setReferenceNumber( arguments.ReferenceNumber );
			
			customerLookupRequest = CreateObject('component', 'cfc.model.carrierservice.Att.CustomerLookupRequest').init();
			customerLookupRequest.setRequestHeader( requestHeader );
			
			switch ( arguments.ActivationType )
			{
				case 'new':
				{
					customerLookupRequest.setOrderType( 'New' );
					break;
				}
				case 'upgrade':
				{
					customerLookupRequest.setOrderType( 'Upgrade' );	
					break;
				}					
				case 'addaline':
				{
					customerLookupRequest.setOrderType( 'AAL' );
					break;
				}		
				default:
				{
					customerLookupRequest.setOrderType( 'New' );
					break;
				}
			}
			
			customerLookupRequest.setBan( '' );
			customerLookupRequest.setBillingZip( arguments.ZipCode );
			customerLookupRequest.setMsiSdn( arguments.Mdn );
			customerLookupRequest.setNumberOfLines( arguments.NumberOfLinesRequested );
			customerLookupRequest.setPin( arguments.Pin );
			
			serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
			serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
			serviceBusRequest.setAction( 'CustomerLookup' );
			serviceBusRequest.setRequestData( customerLookupRequest );
			
			serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
			
			
			//dump(carrierResponse.ResponseStatus, true);
			
			switch( serviceBusReponse.ResponseStatus.ErrorCode )
			{
				case '0':
				{
					carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
					
					if ( carrierResponse.ResponseStatus.ErrorCode eq '00000')
					{
						//dump(carrierResponse, 1);
						
						if ( Len(carrierResponse.CustomerAccountPassword) )
						{
							//TODO: check against form pass code if AT&T Requires it 
						}
								
						//Map successful lookup response to CarrierAccount
						carrierAccount = CreateObject('component', 'fw.model.carrier.account.CarrierAccount').init();
									
						for (i=1; i <= ArrayLen(carrierResponse.CustomerInquiryLines); i++)
						{
							carrierAccountLine = CreateObject('component', 'fw.model.carrier.account.CarrierAccountLine').init();
							carrierAccountLine.setMdn( carrierResponse.CustomerInquiryLines[i].Mdn );
							carrierAccountLine.setIsUpgradeEligible( carrierResponse.CustomerInquiryLines[i].EquipmentUpgradeAvailable );
							ArrayAppend( accountLines, carrierAccountLine );
						}
						
						//dump(accountLines, 1);
						
						carrierAccount.setAccountNumber( carrierResponse.CustomerAccountNumber );
						carrierAccount.setAccountLines( accountLines  );
					}
					else if ( carrierResponse.ResponseStatus.ErrorCode eq '1')
					{
						throw( carrierResponse.ResponseStatus.ErrorCode, carrierResponse.ResponseStatus.Message, 'CustomerNotFound' );
					}
					else
					{
						throw( carrierResponse.ResponseStatus.ErrorCode, carrierResponse.ResponseStatus.Message, 'RequestExecutionFailure' );
					}

					break;
				}
				case 'RequestExecutionFailure':
					throw( serviceBusReponse.ResponseStatus.ErrorCode, serviceBusReponse.ResponseStatus.Message, 'RequestExecutionFailure' );
					break;
				case 'HeaderValidationFailure':
					throw( serviceBusReponse.ResponseStatus.ErrorCode, serviceBusReponse.ResponseStatus.Message, 'HeaderValidationFailure' );
					break;
				case 'RequestValidationFailure':
					throw( serviceBusReponse.ResponseStatus.ErrorCode, serviceBusReponse.ResponseStatus.Message, 'RequestValidationFailure' );
					break;
				case 'CommunicationFailure':
					throw( serviceBusReponse.ResponseStatus.ErrorCode, serviceBusReponse.ResponseStatus.Message, 'CommunicationFailure' );
					break;
				default:
					throw( serviceBusReponse.ResponseStatus.ErrorCode, serviceBusReponse.ResponseStatus.Message, 'UnknownError' );
					break;
			}
		</cfscript>
		
		<cfreturn carrierAccount />
	</cffunction>


	<cffunction name="getMockCustomerAccount" access="public" output="false" returntype="fw.model.carrier.account.CarrierAccount">
        <cfargument name="CarrierId" type="string" required="true" />
        <cfargument name="Mdn" type="string" required="true" />
        <cfargument name="ZipCode" type="string" required="true" />
        <cfargument name="Pin" type="string" default="" required="false" />
        <cfargument name="ReferenceNumber" type="string" default="" required="false" />
		<cfargument name="AccountPassword" type="string" default="" required="false" />
		<cfargument name="LastFourSsn" type="string" default="" required="false" />
		<cfargument name="SecurityQuestionAnswer" type="string" default="" required="false" />
		<cfargument name="ServiceZipCode" type="string" default="" required="false" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="NumberOfLinesRequested" type="numeric" default="0" required="false" />
		<cfargument name="ResultCode" type="string" default="" required="false" />
		
		<cfscript>
			var carrierAccountLine = CreateObject('component', 'fw.model.carrier.account.CarrierAccountLine').init();
			var carrierAccount = CreateObject('component', 'fw.model.carrier.account.CarrierAccount').init();
			var accountLines = [];
			
			carrierAccountLine.setMdn( arguments.Mdn );
			
			if ( arguments.ResultCode eq 'CL001-B')
				carrierAccountLine.setIsUpgradeEligible( false );
			else
				carrierAccountLine.setIsUpgradeEligible( true );
			
			ArrayAppend( accountLines, carrierAccountLine );
			
			carrierAccount.setAccountNumber( '987654321');
			carrierAccount.setAccountLines( accountLines );
		</cfscript>
		
		<cfreturn carrierAccount />
	</cffunction>






	<cffunction name="sortNpaList" access="private" output="false" returntype="array">
		<cfargument name="NpaList" type="array" required="true" />
		
		<cfscript>
			var sortedNpaList = arguments.NpaList;
		</cfscript>
		
		<cfreturn sortedNpaList />
	</cffunction>
		
</cfcomponent>