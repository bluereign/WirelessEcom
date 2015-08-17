<cfcomponent displayname="AddressValidationService" output="false">
	
	<cffunction name="init" returntype="AddressValidationService" output="false">
		<cfreturn this />
	</cffunction>

	<!---
		AV003 - Success
		AV004 - Billing not valid
		AV002 - Shipping not valid at all
		AV001 - Shipping not valid, suggested changes
		AV010 - Invalid Request
		AV011 - Unable to Connect to Carrier Service
		AV012 - Service Timeout
	 --->
	<cffunction name="validateAddress" access="public" returntype="cfc.model.Response" output="false">
		<cfargument name="address" type="Address" required="true" />
		<cfargument name="addressType" type="string" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		<cfargument name="validateWithCarrier" type="string" required="false" default="" />
		<cfargument name="resultCode" type="string" required="false" default="" />
		<cfargument name="ServiceZipCode" type="string" required="false" default="" />

		<cfset var local = structNew() />
		<cfset local.address = arguments.address />
		<cfset local.addressType = trim(arguments.addressType) />
		<cfset local.referenceNumber = trim(arguments.referenceNumber) />
		<cfset local.validateWithCarrier = trim(arguments.validateWithCarrier) />
		<cfset local.resultCode = trim(arguments.resultCode) />
		<cfset local.myResponse = createobject('component', 'cfc.model.Response').init() />
		<cfset local.result = structNew() />

		<cfif len(local.resultCode) eq 0>
			<cfswitch expression="#local.validateWithCarrier#">
				<cfcase value="42"><!--- Verizon --->
					<cfscript>
						local.request.addressToValidate = structNew();
						local.request.addressToValidate.addressLine1 = trim(local.address.getAddressLine1());
						local.request.addressToValidate.addressLine2 = trim(local.address.getAddressLine2());
						local.request.addressToValidate.addressLine3 = '';
						local.request.addressToValidate.city = trim(local.address.getCity());
						local.request.addressToValidate.state = trim(local.address.getState());
						local.request.addressToValidate.country = trim(local.address.getCountry());
						local.request.addressToValidate.zipcode = left(trim(local.address.getZipCode()), 5);
						local.request.addressToValidate.extendedZipCode = '';
						local.request.addressToValidate.name = structNew();
						local.request.addressToValidate.name.firstName = trim(local.address.getFirstName());
						local.request.addressToValidate.name.middleInitial = '';
						local.request.addressToValidate.name.lastName = trim(local.address.getLastName());
						local.request.addressToValidate.name.prefix = '';
						local.request.addressToValidate.name.suffix = '';
						local.request.addressToValidate.contact = structNew();
						local.request.addressToValidate.contact.workPhone = trim(local.address.getDayPhone());
						local.request.addressToValidate.contact.eveningPhone = trim(local.address.getEvePhone());
						local.request.addressToValidate.contact.cellPhone = '';
						local.request.addressToValidate.contact.workPhoneExt = '';
						local.request.addressToValidate.contact.email = '';
						local.request.addressToValidate.companyName = trim(local.address.getCompany());
					</cfscript>

	
					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
						requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
						requestHeader.setReferenceNumber( local.referenceNumber );
						
						addressValidationRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.AddressValidationRequest').init();
						addressValidationRequest.setRequestHeader( requestHeader );
						addressValidationRequest.setAddressLine1( trim(local.address.getAddressLine1()) );
						addressValidationRequest.setAddressLine2( trim(local.address.getAddressLine2()) );
						addressValidationRequest.setAddressLine3( '' );
						addressValidationRequest.setCity( trim(local.address.getCity()) );
						addressValidationRequest.setState( trim(local.address.getState()) );
						addressValidationRequest.setCountry( trim(local.address.getCountry()) );
						addressValidationRequest.setZipCode( left(trim(local.address.getZipCode()), 5) );
						addressValidationRequest.setExtendedZipCode( '' );
						
						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon ); 
						serviceBusRequest.setAction( 'AddressValidation' );
						serviceBusRequest.setRequestData( addressValidationRequest );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
						
											
						//application.model.Util.cfdump( carrierResponse );
						//application.model.Util.cfabort();
												
					
						switch(serviceBusReponse.ResponseStatus.ErrorCode)
						{
							case '0':
							{
								local.myResponse.setResultCode('AV003');
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
						
								if ( carrierResponse.ResponseStatus.ErrorCode eq '00000' )
								{					
									local.returnAddress = createobject('component', 'Address').init();
									local.returnAddress.setAddressLine1( carrierResponse.ValidAddress.AddressLine1 );
									local.returnAddress.setAddressLine2( carrierResponse.ValidAddress.AddressLine2 );
									local.returnAddress.setCity( carrierResponse.ValidAddress.City );
									local.returnAddress.setState( carrierResponse.ValidAddress.State );
									local.returnAddress.setZipCode(left( carrierResponse.ValidAddress.ZipCode , 5));
									local.returnAddress.setZipCodeExtension( carrierResponse.ValidAddress.ExtendedZipCode );
									local.returnAddress.setCountry( carrierResponse.ValidAddress.Country );
							
									local.result.address = local.returnAddress;
								}
								else
								{
									local.myResponse.setResultCode('AV002');
									local.myResponse.setErrorMessage( carrierResponse.ResponseStatus.Message );
								}
						
								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('AV002');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('AV010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('AV010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('AV011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('AV011');
								break;
							}
							
						}
					</cfscript>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>
				<cfcase value="109"><!--- ATT --->

					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
						requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
						requestHeader.setReferenceNumber( local.referenceNumber );
						
						addressValidationRequest = CreateObject('component', 'cfc.model.carrierservice.Att.AddressValidationRequest').init();
						addressValidationRequest.setRequestHeader( requestHeader );
						addressValidationRequest.setAddressLine1( trim(local.address.getAddressLine1()) );
						addressValidationRequest.setAddressLine2( trim(local.address.getAddressLine2()) );
						addressValidationRequest.setAddressLine3( '' );
						addressValidationRequest.setCity( trim(local.address.getCity()) );
						addressValidationRequest.setState( trim(local.address.getState()) );
						addressValidationRequest.setCountry( trim(local.address.getCountry()) );
						addressValidationRequest.setZipCode( left(trim(local.address.getZipCode()), 5) );
						addressValidationRequest.setCompanyName( trim(local.address.getCompany()) );
						addressValidationRequest.setAddressType( 'Shipping' );
						
						addressValidationRequest.setFirstName( trim(local.address.getFirstName()) );
						addressValidationRequest.setLastName( trim(local.address.getLastName()) );
						addressValidationRequest.setMiddleInitial( '' );
						addressValidationRequest.setPrefix( '' );
						addressValidationRequest.setSuffix( '' );
						
						addressValidationRequest.setCellPhone( '' );
						addressValidationRequest.setEmail( '' );
						addressValidationRequest.setEveningPhone( trim(local.address.getEvePhone()) );
						addressValidationRequest.setWorkPhone( trim(local.address.getDayPhone()) );
						addressValidationRequest.setWorkPhoneExt( '' );
						
						
						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT ); 
						serviceBusRequest.setAction( 'ValidateAddress' );
						serviceBusRequest.setRequestData( addressValidationRequest );
						
						//application.model.Util.cfdump( serviceBusRequest.toJson() );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
						
											


						switch(serviceBusReponse.ResponseStatus.ErrorCode)
						{
							case '0':
							{

					//application.model.Util.cfdump( serviceBusReponse.ResponseData );


								local.myResponse.setResultCode('AV003');
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );

					//application.model.Util.cfdump( carrierResponse );
					//application.model.Util.cfabort();
						
								if ( carrierResponse.ResponseStatus.ErrorCode eq '00000' )
								{					
									local.returnAddress = createobject('component', 'Address').init();
									local.returnAddress.setAddressLine1( carrierResponse.ValidAddress.AddressLine1 );
									//local.returnAddress.setAddressLine2( carrierResponse.ValidAddress.AddressLine2 );
									local.returnAddress.setCity( carrierResponse.ValidAddress.City );
									local.returnAddress.setState( carrierResponse.ValidAddress.State );
									local.returnAddress.setZipCode( left( carrierResponse.ValidAddress.ZipCode , 5) );
									local.returnAddress.setZipCodeExtension( carrierResponse.ValidAddress.ExtendedZipCode );
									local.returnAddress.setCountry( carrierResponse.ValidAddress.Country );
							
									local.result.address = local.returnAddress;
								}
								else
								{
									local.myResponse.setResultCode('AV002');
									local.myResponse.setErrorMessage( carrierResponse.ResponseStatus.Message );
								}
						
								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('AV002');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('AV010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('AV010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('AV011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('AV011');
								break;
							}
						}
					</cfscript>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>
				
				<!--- TMO --->
				<cfcase value="128">
					<cfscript>
						local.request.addressToValidate = structNew();
						local.request.addressToValidate.addressLine1 = trim(local.address.getAddressLine1());
						local.request.addressToValidate.addressLine2 = trim(local.address.getAddressLine2());
						local.request.addressToValidate.addressLine3 = '';
						local.request.addressToValidate.city = trim(local.address.getCity());
						local.request.addressToValidate.state = trim(local.address.getState());
						local.request.addressToValidate.country = trim(local.address.getCountry());
						local.request.addressToValidate.zipcode = left(trim(local.address.getZipCode()), 5);
						local.request.addressToValidate.extendedZipCode = '';
						local.request.addressToValidate.name = structNew();
						local.request.addressToValidate.name.firstName = trim(local.address.getFirstName());
						local.request.addressToValidate.name.middleInitial = '';
						local.request.addressToValidate.name.lastName = trim(local.address.getLastName());
						local.request.addressToValidate.name.prefix = '';
						local.request.addressToValidate.name.suffix = '';
						local.request.addressToValidate.contact = structNew();
						local.request.addressToValidate.contact.workPhone = trim(local.address.getDayPhone());
						local.request.addressToValidate.contact.eveningPhone = trim(local.address.getEvePhone());
						local.request.addressToValidate.contact.cellPhone = '';
						local.request.addressToValidate.contact.workPhoneExt = '';
						local.request.addressToValidate.contact.email = '';
						local.request.addressToValidate.companyName = trim(local.address.getCompany());
					</cfscript>

					<cftry>
						<cfinvoke webservice="#trim(request.config.tmobileEndPoint)#" method="ValidateAddress" returnvariable="local.resValidateAddress">
							<cfinvokeargument name="addressToValidate" value="#local.request.addressToValidate#" />
							<cfinvokeargument name="addressType" value="#local.addressType#" />
							<cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
						</cfinvoke>

						<cfcatch type="any">
							<cfset local.hasValidAddress = false />
							<cfset local.hasErrors = true />

							<cfset local.myResponse.setResultCode('AV010') />
							<cfset local.result = {} />
						</cfcatch>
					</cftry>

					<cfif not structKeyExists(local, 'hasErrors') and local.resValidateAddress.getErrorCode() is '0'>
						<cfset local.hasValidAddress = false />

						<cftry>
							<cfset local.resValidateAddress.getValidAddress().getAddressLine1() />
							<cfset local.hasValidAddress = true />

							<cfcatch type="any">
								<!--- Do Nothing --->
							</cfcatch>
						</cftry>

						<cfif local.hasValidAddress>
							<cfset local.myResponse.setResultCode('AV003') />

							<cfset local.returnAddress = createobject('component', 'Address').init() />
							<cfset local.returnAddress.setAddressLine1(local.resValidateAddress.getValidAddress().getAddressLine1()) />
							<cfset local.returnAddress.setAddressLine2(local.resValidateAddress.getValidAddress().getAddressLine2()) />
							<cfset local.returnAddress.setCity(local.resValidateAddress.getValidAddress().getCity()) />
							<cfset local.returnAddress.setState(local.resValidateAddress.getValidAddress().getState()) />
							<cfset local.returnAddress.setZipCode(left(local.resValidateAddress.getValidAddress().getZipCode(), 5)) />
							<cfset local.returnAddress.setZipCodeExtension(local.resValidateAddress.getValidAddress().getExtendedZipCode()) />
							<cfset local.returnAddress.setCountry('US') />

							<cfset local.result.address = local.returnAddress />
						<cfelse>
							<cfset local.myResponse.setResultCode('AV002') />
							<cfset local.result = {} />
						</cfif>
					<cfelse>
						<cfset local.myResponse.setResultCode('AV012') />
						<cfset local.result = {} />
					</cfif>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>
				<cfcase value="299,81"> <!--- Sprint & Boost --->
					
					<cfscript>
						local.request.addressToValidate = structNew();
						local.request.addressToValidate.addressLine1 = trim(local.address.getAddressLine1());
						local.request.addressToValidate.addressLine2 = trim(local.address.getAddressLine2());
						local.request.addressToValidate.addressLine3 = '';
						local.request.addressToValidate.city = trim(local.address.getCity());
						local.request.addressToValidate.state = trim(local.address.getState());
						local.request.addressToValidate.country = trim(local.address.getCountry());
						local.request.addressToValidate.zipcode = left(trim(local.address.getZipCode()), 5);
						local.request.addressToValidate.extendedZipCode = '';
						local.request.addressToValidate.name = structNew();
						local.request.addressToValidate.name.firstName = trim(local.address.getFirstName());
						local.request.addressToValidate.name.middleInitial = '';
						local.request.addressToValidate.name.lastName = trim(local.address.getLastName());
						local.request.addressToValidate.name.prefix = '';
						local.request.addressToValidate.name.suffix = '';
						local.request.addressToValidate.contact = structNew();
						local.request.addressToValidate.contact.workPhone = trim(local.address.getDayPhone());
						local.request.addressToValidate.contact.eveningPhone = trim(local.address.getEvePhone());
						local.request.addressToValidate.contact.cellPhone = '';
						local.request.addressToValidate.contact.workPhoneExt = '';
						local.request.addressToValidate.contact.email = '';
						local.request.addressToValidate.companyName = trim(local.address.getCompany());
					</cfscript>

					<cftry>
						<cfinvoke webservice="#trim(request.config.sprintEndPoint)#" method="ValidateAddress" returnvariable="local.resValidateAddress">
							<cfinvokeargument name="addressToValidate" value="#local.request.addressToValidate#" />
							<cfinvokeargument name="addressType" value="#local.addressType#" />
							<cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
						</cfinvoke>

						<cfcatch type="any">
							<cfset local.hasValidAddress = false />
							<cfset local.hasErrors = true />

							<cfset local.myResponse.setResultCode('AV010') />
							<cfset local.result = {} />
						</cfcatch>
					</cftry>

					<cfif not structKeyExists(local, 'hasErrors') and local.resValidateAddress.getErrorCode() is '0'>
						<cfset local.hasValidAddress = false />

						<cftry>
							<cfset local.resValidateAddress.getValidAddress().getAddressLine1() />
							<cfset local.hasValidAddress = true />

							<cfcatch type="any">
								<!--- Do Nothing --->
							</cfcatch>
						</cftry>

						<cfif local.hasValidAddress>
							<cfset local.myResponse.setResultCode('AV003') />

							<cfset local.returnAddress = createobject('component', 'Address').init() />
							<cfset local.returnAddress.setAddressLine1(local.resValidateAddress.getValidAddress().getAddressLine1()) />
							<cfset local.returnAddress.setAddressLine2(local.resValidateAddress.getValidAddress().getAddressLine2()) />
							<cfset local.returnAddress.setCity(local.resValidateAddress.getValidAddress().getCity()) />
							<cfset local.returnAddress.setState(local.resValidateAddress.getValidAddress().getState()) />
							<cfset local.returnAddress.setZipCode(left(local.resValidateAddress.getValidAddress().getZipCode(), 5)) />
							<cfset local.returnAddress.setZipCodeExtension(local.resValidateAddress.getValidAddress().getExtendedZipCode()) />
							<cfset local.returnAddress.setCountry('US') />

							<cfset local.result.address = local.returnAddress />
						<cfelse>
							<cfset local.myResponse.setResultCode('AV002') />
							<cfset local.result = {} />
						</cfif>
					<cfelse>
						<cfset local.myResponse.setResultCode('AV012') />
						<cfset local.result = {} />
					</cfif>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>
				<cfdefaultcase>
					<cfset local.myResponse.setResultCode('AV003') />
					<cfset local.result.address = local.address />
				</cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfswitch expression="#local.resultCode#">
				<cfcase value="AV001">
					<cfset local.myResponse.setResultCode('AV001') />

					<cfset local.result.matchingAddresses = arrayNew(1) />

					<cfloop from="1" to="3" index="local.idx">
						<cfset local.returnAddress = createobject('component', 'Address').init() />
						<cfset local.returnAddress.setAddressLine1(local.address.getAddressLine1(0)) />
						<cfset local.returnAddress.setAddressLine2(local.address.getAddressLine2()) />
						<cfset local.returnAddress.setCity(local.address.getCity()) />
						<cfset local.returnAddress.setState(local.address.getState()) />
						<cfset local.returnAddress.setZipCode(left(local.address.getZipcode(), 5)) />
						<cfset local.returnAddress.setCountry('US') />

						<cfset local.result.matchingAddresses[local.idx] = local.returnAddress />
					</cfloop>
				</cfcase>

				<cfcase value="AV002">
					<cfset local.myResponse.setResultCode('AV002') />
					<cfset local.result.matchingAddresses = arrayNew(1) />
				</cfcase>

				<cfcase value="AV003">
					<cfset local.myResponse.setResultCode('AV003') />
					<cfset local.result.address = local.address />
					<cfset local.result.address.setAddressLine1(local.address.getAddressLine1()) />
				</cfcase>

				<cfcase value="AV004">
					<cfset local.myResponse.setResultCode('AV004') />
					<cfset local.result = {} />
				</cfcase>

				<cfcase value="AV010">
					<cfset local.myResponse.setResultCode('AV010') />
					<cfset local.result = {} />
				</cfcase>

				<cfcase value="AV011">
					<cfset local.myResponse.setResultCode('AV011') />
					<cfset local.result = {} />
				</cfcase>

				<cfcase value="AV012">
					<cfset local.myResponse.setResultCode('AV012') />
					<cfset local.result = {} />
				</cfcase>

				<cfdefaultcase>
					<cfthrow message="ResultCode passed in is not defined." />
				</cfdefaultcase>
			</cfswitch>

			<cfset local.myResponse.setResult(local.result) />
		</cfif>

		<cfreturn local.myResponse />
	</cffunction>
</cfcomponent>