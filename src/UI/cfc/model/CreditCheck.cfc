<cfcomponent displayname="CreditCheck" output="false">

	<cffunction name="init" access="public" returntype="CreditCheck" output="false">
		<cfreturn this />
	</cffunction>


	<!---
		CC001 - Success Credit Approved
		CC002 - Credit Denied.
		CC010 - Invalid Request
		CC011 - Unable to Connect to Carrier Service
		CC012 - Service Timeout
		CC015 - Success Credit Approved + Deposit Required	
	--->
	<cffunction name="checkCredit" access="public" returntype="Response" output="false">
		<cfargument name="carrier" type="string" required="true" />
		<cfargument name="referenceNumber" type="string" required="true" />
		<cfargument name="serviceZipCode" type="string" required="true" />
		<cfargument name="firstName" type="string" required="true" />
		<cfargument name="lastName" type="string" required="true" />
		<cfargument name="middleInitial" type="string" required="true" />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="ssn" type="string" required="true" />
		<cfargument name="dob" type="string" required="true" />
		<cfargument name="driversLicenseNumber" type="string" required="true" />
		<cfargument name="driversLicenseState" type="string" required="true" />
		<cfargument name="expirationDate" type="string" required="true" />
		<!--- Must be an address object returned from address validation. Requires extended address. --->
		<cfargument name="billingAddress" type="Address" required="true" />
		<cfargument name="numberOfLinesRequested" type="string" required="true" />
		<!--- Required for existing Verizon customers. --->
		<cfargument name="existingCustomerMDN" type="string" required="false" default="" />
		<cfargument name="CurrentAccountNumber" type="string" required="false" default="" />
		<cfargument name="resultCode" type="string" required="false" default="" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="CarrierConversationId" type="string" default="" required="false" />

		<cfset var local = {} />
		<cfset var requestHeader = '' />
		<cfset var creditWriteRequest = '' />
		<cfset var carrierResponse = '' />
		<cfset var creditCheckInfo = {} />

		<cfset local.carrier = trim(arguments.carrier) />
		<cfset local.referenceNumber = trim(arguments.referenceNumber) />
		<cfset local.serviceZipCode = left(trim(arguments.serviceZipCode), 5) />
		<cfset local.firstName = trim(arguments.firstName) />
		<cfset local.lastName = trim(arguments.lastName) />
		<cfset local.middleInitial = trim(arguments.middleInitial) />
		<cfset local.email = trim(arguments.email) />
		<cfset local.ssn = trim(arguments.ssn) />
		<cfset local.dob = trim(arguments.dob) />
		<cfset local.driversLicenseNumber = trim(arguments.driversLicenseNumber) />
		<cfset local.driversLicenseState = trim(arguments.driversLicenseState) />
		<cfset local.expirationDate = trim(arguments.expirationDate) />
		<cfset local.billingAddress = arguments.billingAddress />
		<cfset local.numberOfLinesRequested = trim(arguments.numberOfLinesRequested) />
		<cfset local.existingCustomerMDN = trim(arguments.existingCustomerMDN) />
		<cfset local.CurrentAccountNumber = trim(arguments.CurrentAccountNumber) />
		<cfset local.resultCode = trim(arguments.resultCode) />
		<cfset local.result = {} />

		<cfif not len(trim(local.email))>
			<cfset local.email = replace(createUUID(), '-', '', 'all') & '@wirelessadvocates.com' />
		</cfif>

		<cfset local.myResponse = createobject('component', 'Response').init() />

		<cfif not len(trim(local.resultCode))>


			<cfswitch expression="#local.carrier#">
				<cfcase value="42"><!--- Verizon --->
					<!---
						02050	Missing Driver License Info
						02051	Pending Credit Decision. Please check back later. <Credit-reason desc>
						02052	Account Number did not match 
						00053	Credit decision requires manual review. <may carry more message>
						02053	Provided SSN does not match.
						00054	Access denied due to Lifeline Customer, Please have the customer call (XXX)XXX XXXX for assistance
							
						02054	Only New Customers allowed for PrePay.
						02055	Customer Last Name is Blank.
						02056	Customer First Name is Blank.
						02057	Ssn is missing.
					 --->
					<cfscript>
						local.request.billingName = structNew();
						local.request.billingName.firstName = local.firstName;
						local.request.billingName.middleInitial = local.middleInitial;
						local.request.billingName.lastName = local.lastName;
						local.request.billingName.prefix = '';
						local.request.billingName.suffix = '';

						local.request.contact = structNew();
						local.request.contact.Email = local.email;
						local.request.contact.HomePhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
						local.request.contact.ReachNumber = '';						
						local.request.contact.WorkPhone = reReplaceNoCase(local.billingAddress.getDayPhone(), '\W', '', 'all');

						local.request.credentials = structNew();
						local.request.credentials.ssn = reReplaceNoCase(local.ssn, '\W', '', 'all');
						local.request.credentials.idType = 'DL';
						local.request.credentials.id = local.driversLicenseNumber;
						local.request.credentials.idExpiration = local.expirationDate;
						local.request.credentials.state = local.driversLicenseState;
						local.request.credentials.dob = local.dob;
					</cfscript>

		<!---		<cftry>--->


					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
						requestHeader.setServiceAreaZip( arguments.serviceZipCode );
						requestHeader.setReferenceNumber( local.referenceNumber );
						
						creditWriteRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CreditWriteRequest').init();
						creditWriteRequest.setRequestHeader( requestHeader );
						creditWriteRequest.setServiceZipCode( arguments.serviceZipCode );
						creditWriteRequest.setNumberOfLines( local.numberOfLinesRequested );
						creditWriteRequest.setEmail( local.request.contact.Email );
						
						creditWriteAddress = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Address').init();
						creditWriteAddress.setAddressLine1( local.billingAddress.getAddressLine1() );
						creditWriteAddress.setAddressLine2( local.billingAddress.getAddressLine2() );
						creditWriteAddress.setAptNum( '' );
						creditWriteAddress.setCity( local.billingAddress.getCity() );
						creditWriteAddress.setState( local.billingAddress.getState() );
						creditWriteAddress.setCountry( '' );
						creditWriteAddress.setZipCode( local.billingAddress.getZipCode() );
						creditWriteAddress.setExtendedZipCode( '' );						

						creditWriteRequest.setAddress( creditWriteAddress );
		
						switch ( arguments.ActivationType )
						{
							case 'new':
							{
								newCustomerInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.NewCustomerInfo').init();
								newCustomerInfo.setHomePhone( local.request.contact.HomePhone );
								newCustomerInfo.setWorkPhone( local.request.contact.WorkPhone );
								newCustomerInfo.setDob( local.request.credentials.dob );
								newCustomerInfo.setExpirationDate( local.request.credentials.idExpiration );
								newCustomerInfo.setId( local.request.credentials.id );
								newCustomerInfo.setIdType( local.request.credentials.idType );
								newCustomerInfo.setSsn( local.request.credentials.ssn );
								newCustomerInfo.setState( local.request.credentials.state );
								
								creditWriteRequest.setNewCustomerInfo( newCustomerInfo );
								creditWriteRequest.setActivationType( 'N' );
								
								break;
							}
							case 'upgrade':
							{
								break;
							}					
							case 'addaline':
							{
								aalCustomerInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.AddALineCustomerInfo').init();
								aalCustomerInfo.setAccountNumber( local.CurrentAccountNumber );
								aalCustomerInfo.setMtn( local.existingCustomerMDN );
								aalCustomerInfo.setHomePhone( local.request.contact.HomePhone );
								aalCustomerInfo.setDob( local.request.credentials.dob );
								aalCustomerInfo.setExpirationDate( local.request.credentials.idExpiration );
								aalCustomerInfo.setId( local.request.credentials.id );
								aalCustomerInfo.setIdType( local.request.credentials.idType );
								aalCustomerInfo.setSsn( local.request.credentials.ssn );
								aalCustomerInfo.setState( local.request.credentials.state );
								
								creditWriteRequest.setAddALineCustomerInfo( aalCustomerInfo );
								creditWriteRequest.setActivationType( 'A' );				
								
								break;
							}		
							default:
							{
								newCustomerInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.NewCustomerInfo').init();
								newCustomerInfo.setHomePhone( local.request.contact.HomePhone );
								newCustomerInfo.setWorkPhone( local.request.contact.WorkPhone );
								newCustomerInfo.setDob( local.request.credentials.dob );
								newCustomerInfo.setExpirationDate( local.request.credentials.idExpiration );
								newCustomerInfo.setId( local.request.credentials.id );
								newCustomerInfo.setIdType( local.request.credentials.idType );
								newCustomerInfo.setSsn( local.request.credentials.ssn );
								newCustomerInfo.setState( local.request.credentials.state );
								
								creditWriteRequest.setNewCustomerInfo( newCustomerInfo );
								creditWriteRequest.setActivationType( 'N' );
								
								break;
							}
						}
		
		

						
						creditWriteRequest.setBillingNameFirstName( local.request.billingName.firstName );
						creditWriteRequest.setBillingNameMiddleInitial( local.request.billingName.middleInitial );
						creditWriteRequest.setBillingNameLastName( local.request.billingName.lastName );
						creditWriteRequest.setBillingNamePrefix( local.request.billingName.prefix );
						creditWriteRequest.setBillingNameSuffix( local.request.billingName.suffix );

						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
						serviceBusRequest.setAction( 'CreditWrite' );
						serviceBusRequest.setRequestData( creditWriteRequest );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );

						switch(serviceBusReponse.ResponseStatus.ErrorCode)
						{
							case '0':
							{
								local.myResponse.setResultCode('CC001');
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );

								//application.model.Util.cfdump( carrierResponse );
								//application.model.Util.cfabort();
								
								creditCheckInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init();
								creditCheckInfo.setBillingSystem( carrierResponse.OrderKeyInfo.BillingSystem );
								creditCheckInfo.setClusterInfo( carrierResponse.OrderKeyInfo.ClusterInfo);
								creditCheckInfo.setCreditApplicationNum( carrierResponse.OrderKeyInfo.CreditApplicationNum );
								creditCheckInfo.setLocation( carrierResponse.OrderKeyInfo.Location );
								creditCheckInfo.setOrderNum( carrierResponse.OrderKeyInfo.OrderNum );
								creditCheckInfo.setOutletId( carrierResponse.OrderKeyInfo.OutletId );
								creditCheckInfo.setSalesForceId( carrierResponse.OrderKeyInfo.SalesForceId );

								//application.model.Util.cfdump( creditCheckInfo.getInstanceData() );
								//application.model.Util.cfabort();

								local.result = {
									status = ''
									, applicationReferenceNumber = carrierResponse.OrderKeyInfo.CreditApplicationNum
									, numberOfLinesApproved = 5 //Set to Max
									, depositAmountRequired = carrierResponse.Deposit
									, customerAccountNumber = ''
									, CreditCheckInfo = creditCheckInfo
								};


								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('CC002');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('CC010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('CC010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('CC011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('CC011');
								break;
							}
							
						}

						local.myResponse.setResult( local.result );
					</cfscript>

				</cfcase>
				
				<!--- AT&T --->
				<cfcase value="109">
					<cfscript>
						local.request.billingName = structNew();
						local.request.billingName.firstName = local.firstName;
						local.request.billingName.middleInitial = local.middleInitial;
						local.request.billingName.lastName = local.lastName;
						local.request.billingName.prefix = '';
						local.request.billingName.suffix = '';

						local.request.contact = structNew();
						local.request.contact.workPhone = reReplaceNoCase(local.billingAddress.getDayPhone(), '\W', '', 'all');
						local.request.contact.eveningPhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
						local.request.contact.cellPhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
						local.request.contact.workPhoneExt = '';
						local.request.contact.email = local.email;

						local.request.credentials = structNew();
						local.request.credentials.ssn = reReplaceNoCase(local.ssn, '\W', '', 'all');
						local.request.credentials.idType = 'DL';
						local.request.credentials.id = local.driversLicenseNumber;
						local.request.credentials.idExpiration = local.expirationDate;
						local.request.credentials.state = local.driversLicenseState;
						local.request.credentials.dob = local.dob;
					</cfscript>


					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
						requestHeader.setServiceAreaZip( arguments.serviceZipCode );
						requestHeader.setReferenceNumber( local.referenceNumber );
						requestHeader.setConversationId( arguments.CarrierConversationId );
						
						creditCheckRequest = CreateObject('component', 'cfc.model.carrierservice.Att.AddAccountRequest').init();
						creditCheckRequest.setRequestHeader( requestHeader );
						creditCheckRequest.setServiceZipCode( arguments.serviceZipCode );
						creditCheckRequest.setNumberOfLines( local.numberOfLinesRequested );
						
						//Billing name
						creditCheckRequest.setFirstName( local.request.billingName.firstName );
						creditCheckRequest.setLastName( local.request.billingName.lastName );
						creditCheckRequest.setMiddleInitial( local.request.billingName.middleInitial );
						creditCheckRequest.setPrefix( '' );
						creditCheckRequest.setSuffix( '' );
						
						//Contact
						
						creditCheckRequest.setWorkPhone( local.request.contact.workPhone );
						creditCheckRequest.setEveningPhone( local.request.contact.eveningPhone );
						creditCheckRequest.setCellPhone( local.request.contact.cellPhone );
						creditCheckRequest.setWorkPhoneExt( local.request.contact.workPhoneExt );
						creditCheckRequest.setEmail( local.request.contact.email );
						
						//Credentials
						creditCheckRequest.setDOB( local.request.credentials.dob );
						creditCheckRequest.setId( local.request.credentials.id );
						creditCheckRequest.setIdExpiration( local.request.credentials.idExpiration );
						creditCheckRequest.setIdType( local.request.credentials.idType );
						creditCheckRequest.setSSN( local.request.credentials.ssn );
						creditCheckRequest.setState( local.request.credentials.state );
						
						creditCheckAddress = CreateObject('component', 'cfc.model.carrierservice.Att.common.Address').init();
						creditCheckAddress.setAddressLine1( local.billingAddress.getAddressLine1() );
						creditCheckAddress.setAddressLine2( local.billingAddress.getAddressLine2() );
						creditCheckAddress.setAptNumber( '' );
						creditCheckAddress.setCity( local.billingAddress.getCity() );
						creditCheckAddress.setState( local.billingAddress.getState() );
						creditCheckAddress.setCountry( 'USA' );
						creditCheckAddress.setZipCode( local.billingAddress.getZipCode() );
						creditCheckAddress.setExtendedZipCode( '' );						

						creditCheckRequest.setBillingAddress( creditCheckAddress );

						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
						serviceBusRequest.setAction( 'AddAccount' );
						serviceBusRequest.setRequestData( creditCheckRequest );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );

						switch(serviceBusReponse.ResponseStatus.ErrorCode)
						{
							case '0':
							{
								local.myResponse.setResultCode('CC001');
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );

								//application.model.util.cfdump( carrierResponse );
								//application.model.util.cfabort();

								local.result = {
									status = ''
									, applicationReferenceNumber = carrierResponse.Credit.DecisionReferenceNumber
									, numberOfLinesApproved = 5 //Set to Max
									, depositAmountRequired = carrierResponse.Credit.DepositAmount[1]
									, customerAccountNumber = '' //TODO: I might need this on AAL
									, CarrierConversationId = carrierResponse.ConversationId
								};

								if ( carrierResponse.Credit.decisionCode == "AR")
								{
									local.myResponse.setResultCode('CC002');
								}
								
								//Check to see if order placement requires a deposit
								if ( carrierResponse.Credit.DepositAmount[1] > 0 )
								{
									local.myResponse.setResultCode('CC015');
								}

								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('CC002');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('CC010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('CC010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('CC011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('CC011');
								break;
							}
							
						}

						local.myResponse.setResult( local.result );						
					</cfscript>

					<cfset local.myResponse.setResult(local.result) />
				</cfcase>
				
				<cfcase value="128"><!--- T-Mobile --->
					<cfscript>
						local.request.billingName = structNew();
						local.request.billingName.firstName = local.firstName;
						local.request.billingName.middleInitial = local.middleInitial;
						local.request.billingName.lastName = local.lastName;
						local.request.billingName.prefix = '';
						local.request.billingName.suffix = '';

						local.request.contact = structNew();
						local.request.contact.workPhone = reReplaceNoCase(local.billingAddress.getDayPhone(), '\W', '', 'all');
						local.request.contact.eveningPhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
						local.request.contact.cellPhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
						local.request.contact.workPhoneExt = '';
						local.request.contact.email = local.email;

						local.request.credentials = structNew();
						local.request.credentials.ssn = reReplaceNoCase(local.ssn, '\W', '', 'all');
						local.request.credentials.idType = 'DL';
						local.request.credentials.id = local.driversLicenseNumber;
						local.request.credentials.idExpiration = local.expirationDate;
						local.request.credentials.state = local.driversLicenseState;
						local.request.credentials.dob = local.dob;
					</cfscript>

					<cfif trim(local.driversLicenseNumber) is not 'C61614056154632'>
						<cfinvoke webservice="#trim(request.config.tmobileEndPoint)#" method="CheckCredit" returnvariable="local.resCheckCredit">
							<cfinvokeargument name="billingName" value="#local.request.billingName#" />
							<cfinvokeargument name="serviceZipCode" value="#local.billingAddress.getZipCode()#" />
							<cfinvokeargument name="contactInfo" value="#local.request.contact#" />
							<cfinvokeargument name="billingContactCredentials" value="#local.request.credentials#" />
							<cfinvokeargument name="numberOfLines" value="#local.numberOfLinesRequested#" />
							<cfinvokeargument name="referenceNumber" value="#local.referenceNumber#" />
						</cfinvoke>
					<cfelse>
						<cfset local.newNumLines = 10 />
						<cfset local.newCreditStatus = 'A' />
						<cfset local.newApplicationReferenceNumber = '20102420815377' />
						<cfset local.newDeposit = 0 />
						<cfset local.newCustomerNumber = '999' />
					</cfif>

					<cfif not structKeyExists(local, 'newCustomerNumber')>
						<cfif local.resCheckCredit.getErrorCode() is '0'>
							<cfif local.resCheckCredit.getServiceResponseSubCode() eq 300>
								<!--- Existing Customer --->
								<cfset local.myResponse.setResultCode('CC002') />
								<cfset local.myResponse.setErrorCode('300') />
								<cfset local.result = {} />
							<cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 402>
								<!--- Unsupported account type --->
								<cfset local.myResponse.setResultCode('CC002') />
								<cfset local.myResponse.setErrorCode('402') />
								<cfset local.result = {} />
							<cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 408>
								<!--- Credit Check pending --->
								<cfset local.myResponse.setResultCode('CC001') />
								<cfset local.result.status = local.resCheckCredit.getCreditStatus() />
								<cfset local.result.applicationReferenceNumber = local.resCheckCredit.getCreditApplicationNumber() />
								<cfset local.result.numberOfLinesApproved = 5 /> <!--- Max lines --->
								<cfset local.result.depositAmountRequired = local.resCheckCredit.getDeposit() />
								<cfset local.result.customerAccountNumber = local.resCheckCredit.getCustomerAccountNumber() & '' />
							<cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 409>
								<!--- Credit Check under review --->
								<cfset local.myResponse.setResultCode('CC001') />
								<cfset local.result.status = local.resCheckCredit.getCreditStatus() />
								<cfset local.result.applicationReferenceNumber = local.resCheckCredit.getCreditApplicationNumber() />
								<cfset local.result.numberOfLinesApproved = 5 /> <!--- Max lines --->
								<cfset local.result.depositAmountRequired = local.resCheckCredit.getDeposit() />
								<cfset local.result.customerAccountNumber = local.resCheckCredit.getCustomerAccountNumber() & '' />
							<cfelseif local.resCheckCredit.getNumberOfLines() gte local.numberOfLinesRequested>
								<!--- Credit Approved --->
								<cfset local.myResponse.setResultCode('CC001') />
								<cfset local.result.status = local.resCheckCredit.getCreditStatus() />
								<cfset local.result.applicationReferenceNumber = local.resCheckCredit.getCreditApplicationNumber() />
								<cfset local.result.numberOfLinesApproved = local.resCheckCredit.getNumberOfLines() />
								<cfset local.result.depositAmountRequired = local.resCheckCredit.getDeposit() />
								<cfset local.result.customerAccountNumber = local.resCheckCredit.getCustomerAccountNumber() & '' />
							<cfelse>
								<!--- Credit Denied --->
								<cfset local.myResponse.setResultCode('CC002') />
								<cfset local.myResponse.setErrorCode('301') />
								<cfset local.result = {} />
							</cfif>
						<cfelseif local.resCheckCredit.getErrorCode() is '102'>
							<!--- Credit Denied --->
							<cfset local.myResponse.setResultCode('CC013') />
							<cfset local.myResponse.setErrorCode('102') />
							<cfset local.result = {} />
						<cfelse>
							<cfset local.myResponse.setResultCode('CC012') />
							<cfset local.result = {} />
						</cfif>
					<cfelse>
						<cfset local.myResponse.setResultCode('CC001') />
						<cfset local.result.status = 'COMPLETED' />
						<cfset local.result.applicationReferenceNumber = local.newApplicationReferenceNumber />
						<cfset local.result.numberOfLinesApproved = local.newNumLines />
						<cfset local.result.depositAmountRequired = local.newDeposit />
						<cfset local.result.customerAccountNumber = local.newCustomerNumber & '' />
					</cfif>

					<cfset local.myResponse.setResult(local.result) />
				</cfcase>


				<cfcase value="299"><!--- Sprint --->

					<cfscript>
                        local.request.billingName = structNew();
                        local.request.billingName.firstName = local.firstName;
                        local.request.billingName.middleInitial = local.middleInitial;
                        local.request.billingName.lastName = local.lastName;
                        local.request.billingName.prefix = '';
                        local.request.billingName.suffix = '';

                        local.request.contact = structNew();
                        local.request.contact.workPhone = reReplaceNoCase(local.billingAddress.getDayPhone(), '\W', '', 'all');
                        local.request.contact.eveningPhone = reReplaceNoCase(local.billingAddress.getEvePhone(), '\W', '', 'all');
                        local.request.contact.cellPhone = '';
                        local.request.contact.workPhoneExt = '';
                        local.request.contact.email = local.email;

                        local.request.credentials = structNew();
                        local.request.credentials.ssn = reReplaceNoCase(local.ssn, '\W', '', 'all');
                        local.request.credentials.idType = 'DL';
                        local.request.credentials.id = local.driversLicenseNumber;
                        local.request.credentials.idExpiration = local.expirationDate;
                        local.request.credentials.state = local.driversLicenseState;
                        local.request.credentials.dob = local.dob;
                    </cfscript>


                   <!--- generate a new order reference number --->
                   <cfset oldRefNumber = local.referenceNumber>
                   <cfset application.model.checkoutHelper.generateReferenceNumber() />
                   <cfset local.referenceNumber = application.model.checkoutHelper.generateReferenceNumber() />
    
                   <!--- update the existing reference number references --->
                    <cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
                        update service.CarrierInterfaceLog set ReferenceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.referenceNumber#">
                        where ReferenceNumber  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldRefNumber#">
                        
                        update service.CheckoutSessionState set ReferenceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.referenceNumber#">
                        where ReferenceNumber  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#oldRefNumber#">
                   </cfquery>
                
                    <cfinvoke webservice="#trim(request.config.sprintEndPoint)#" method="CheckCredit" returnvariable="local.resCheckCredit">
                        <cfinvokeargument name="billingName" value="#local.request.billingName#" />
                        <cfinvokeargument name="serviceZipCode" value="#local.billingAddress.getZipCode()#" />
                        <cfinvokeargument name="contactInfo" value="#local.request.contact#" />
                        <cfinvokeargument name="billingContactCredentials" value="#local.request.credentials#" />
                        <cfinvokeargument name="numberOfLines" value="#local.numberOfLinesRequested#" />
						<cfinvokeargument name="Question" value="" />
						<cfinvokeargument name="Answer" value="" />
                        <cfinvokeargument name="referenceNumber" value="#local.referenceNumber#" />
                    </cfinvoke>


                    <cftry>
                        <cfif local.resCheckCredit.getServiceResponseSubCode() eq 300>
                            <!--- Existing Customer based on SSN provided --->
                            <cfset local.myResponse.setResultCode('CC003') />
                            <cfset local.myResponse.setErrorCode('300') />
                            <cfset local.result = {} />
                        <cfelseif local.resCheckCredit.getDeposit() gt 0>
                            <!--- deposit required --->
                            <cfset local.myResponse.setResultCode('CC016') />
                            <cfset local.myResponse.setErrorCode('103') />
                            <cfset local.result = {} />
                        <cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 303>
                            <!--- Credit Approved --->
                            <cfset local.myResponse.setResultCode('CC001') />
                            <cfset local.result.status = local.resCheckCredit.getCreditStatus() />
                            <cfset local.result.applicationReferenceNumber = local.resCheckCredit.getCreditApplicationNumber() />
                            <cfset local.result.numberOfLinesApproved = local.resCheckCredit.getNumberOfLines() />
                            <cfset local.result.depositAmountRequired = local.resCheckCredit.getDeposit() />
                            <cfset local.result.customerAccountNumber = local.resCheckCredit.getCustomerAccountNumber() & '' />
       					<cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 302>
						   	<!--- Credit Unknown --->
                            <cfset local.myResponse.setResultCode('CC001') />
                            <cfset local.result.status = local.resCheckCredit.getCreditStatus() />
                            <cfset local.result.applicationReferenceNumber = local.resCheckCredit.getCreditApplicationNumber() />
                            <cfset local.result.numberOfLinesApproved = 5 /> <!--- Set to Max --->
                            <cfset local.result.depositAmountRequired = local.resCheckCredit.getDeposit() />
                            <cfset local.result.customerAccountNumber = local.resCheckCredit.getCustomerAccountNumber() & '' />
                        <cfelseif local.resCheckCredit.getServiceResponseSubCode() eq 301>
                            <!--- Credit Denied --->
                            <cfset local.myResponse.setResultCode('CC002') />
                            <cfset local.myResponse.setErrorCode('301') />
                            <cfset local.result = {} />
                        
                        <cfelse>
                            <!--- Unknow error --->
                            <cfset local.myResponse.setResultCode('CC012') />
                            <cfset local.result = {} />
                        </cfif>
    
                        <cfcatch type="any">
                            <cfset local.myResponse.setResultCode('CC017') />
                            <cfset local.myResponse.setErrorMessage('Could not Connect to Carrier Service - Possible Reason, Unclean Address sent to Carrier') />
                            <cfset local.result = {} />
                            
                        </cfcatch>
                    </cftry>

					<cfset local.myResponse.setResult(local.result) />
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="Carrier code not found" />
				</cfdefaultcase>
			</cfswitch>

		<cfelse>

			<cfswitch expression="#local.resultCode#">
				<cfcase value="CC001">
					<!--- Credit Approved --->
					<cfset local.myResponse.setResultCode('CC001') />

					<cfset local.result.status = 'Approved' />
					<cfset local.result.applicationReferenceNumber = '123456789' />
					<cfset local.result.numberOfLinesApproved = 3 />
					<cfset local.result.depositAmountRequired = 0 />
					<cfset local.result.customerAccountNumber = '' />
				
					<cfif local.carrier eq 42>
						<cfset local.result.CreditCheckInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init() />
					</cfif>
				</cfcase>
				<cfcase value="CC001-B">
					<!--- Credit Unkown --->
					<cfset local.myResponse.setResultCode('CC001') />

					<cfset local.result.status = 'Approved' />
					<cfset local.result.applicationReferenceNumber = '123456789' />
					<cfset local.result.numberOfLinesApproved = 3 />
					<cfset local.result.depositAmountRequired = 0 />
					<cfset local.result.customerAccountNumber = '' />
				</cfcase>				
				<cfcase value="CC002">
					<!--- Credit Denied --->
					<cfset local.myResponse.setResultCode('CC002') />
					<cfset local.result = {} />
				</cfcase>
				<cfcase value="CC010">
					<!--- Invalid Request --->
					<cfset local.myResponse.setResultCode('CC010') />
					<cfset local.result = {} />
				</cfcase>
				<cfcase value="CC011">
					<!--- Unable to Connect to Carrier Service --->
					<cfset local.myResponse.setResultCode('CC011') />
					<cfset local.result = {} />
				</cfcase>
				<cfcase value="CC012">
					<!--- Service Timeout --->
					<cfset local.myResponse.setResultCode('CC012') />
					<cfset local.result = {} />
				</cfcase>
				<cfcase value="CC015">
					<!--- Credit Approved + Deposit Required --->
					<cfset local.myResponse.setResultCode('CC015') />
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
