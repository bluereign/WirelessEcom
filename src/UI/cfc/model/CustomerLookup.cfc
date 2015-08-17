<cfcomponent output="false" displayname="CustomerLookup">

	<cffunction name="init" access="public" returntype="CustomerLookup" output="false">
		<cfreturn this />
	</cffunction>

	<!---
		CL001 - Success Customer Found
		CL001-B - Success Customer Found - No Add-a-Line Available
		CL001-C - Success Customer Found - Not Upgrade Eligible
		CL001-D - Success Customer Found - On Family Plan but Service says Individual
        CL002 - Customer not Found
		CL010 - Invalid Request
		CL011 - Unable to Connect to Carrier Service
		CL012 - Service Timeout
	 --->
    <cffunction name="lookup" access="public" returntype="cfc.model.Response" output="false">

        <cfargument name="carrier" type="string" required="true" />
        <cfargument name="mdn" type="string" required="true" />
        <cfargument name="zipCode" type="string" required="true" />
        <cfargument name="pin" type="string" required="false" />
        <cfargument name="ReferenceNumber" type="string" required="false" />
        <cfargument name="ResultCode" type="string" required="false" default="" />
		<cfargument name="AccountPassword" type="string" required="false" default="" />
		<cfargument name="LastFourSsn" type="string" required="false" default="" />
		<cfargument name="SecurityQuestionAnswer" type="string" required="false" default="" />
		<cfargument name="ServiceZipCode" type="string" required="false" default="" />
		<cfargument name="ActivationType" type="string" default="" required="false" />
		<cfargument name="NumberOfLinesRequested" type="numeric" default="0" required="false" />
		<cfargument name="CarrierConversationId" type="string" default="" required="false" />

		<cfset var webservice = '' />
		<cfset var response = '' />
		<cfset var serviceResponse = '' />
		<cfset var result = {} />
		<cfset var requestHeader = '' />
		<cfset var customerLookupRequest = '' />
		<cfset var carrierResponse = '' />
		<cfset var currentLine = '' />
		<cfset var i = 0 />

		<cfset var local = {} />
        <cfset local.resultCode = trim(arguments.resultCode) />
        <cfset local.carrier = trim(arguments.carrier) />
        <cfset local.mdn = trim(arguments.mdn) />
        <cfset local.zipCode = trim(arguments.zipCode) />
        <cfset local.pin = trim(arguments.pin) />
		<cfset local.AccountPassword = trim(arguments.AccountPassword) />
		<cfset local.LastFourSsn = trim(arguments.LastFourSsn) />
		<cfset local.SecurityQuestionAnswer = trim(arguments.SecurityQuestionAnswer) />
        <cfset local.referenceNumber = trim(arguments.referenceNumber) />
        <cfset local.myResponse = createobject('component','cfc.model.Response').init() />



        <cfif Len(local.resultCode) eq 0>
        	<!--- call the carrier services --->

            <!--- Determine Carrier / Invoke Credit Check --->

            <cfswitch expression="#local.carrier#">
                <cfcase value="42"> <!--- VERIZON --->

					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
						requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
						requestHeader.setReferenceNumber( local.referenceNumber );
						
						customerLookupRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CustomerLookupRequest').init();
						customerLookupRequest.setRequestHeader( requestHeader );
						customerLookupRequest.setZipCode( local.zipCode );
						customerLookupRequest.setMdn( local.mdn );
						customerLookupRequest.setSecretKey( local.accountPassword ); //TODO: Get Account Password
						customerLookupRequest.setSSN( local.pin );
						
						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
						serviceBusRequest.setAction( 'CustomerLookup' );
						serviceBusRequest.setRequestData( customerLookupRequest );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
						
						//application.model.Util.cfdump( serviceBusReponse );
						//application.model.Util.cfabort();
						
						switch( serviceBusReponse.ResponseStatus.ErrorCode )
						{
							case '0':
							{
								local.myResponse.setResultCode('CL001');
								local.hasMatchingLine = false;
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
	
								if ( carrierResponse.ResponseStatus.ErrorCode eq '00000')
								{
									//application.model.Util.cfdump( carrierResponse );
									//application.model.Util.cfabort(  );
									
									result.User = createobject('component', 'cfc.model.User').init();
	
									result.User.setLinesApproved( carrierResponse.Account.LinesApproved -  carrierResponse.Account.LinesUsed);
									result.User.setLinesActive( carrierResponse.Account.LinesUsed );
									result.CarrierPlanType = carrierResponse.Account.LineInfo.PlanInfo.PlanType;
	                              	result.CustomerAccountNumber = carrierResponse.Account.AccountNumber;
									result.CanUpgradeEquipment = carrierResponse.Account.LineInfo.EligibleForUpgrade;
									result.EquipmentUpgradeEligibilityDate = carrierResponse.Account.LineInfo.EqptUpgdEligibilityDate;
									result.CarrierPlanId = carrierResponse.Account.LineInfo.PlanInfo.PricePlanId;
									result.DeviceFamily = carrierResponse.Account.LineInfo.DeviceInfo.DeviceFamily;
									result.DeviceCap = 0;
									result.DeviceCapUsed = 0;
									result.CurrentImei = '';
									
									if ( StructKeyExists( carrierResponse.Account, 'AlpPlanInfo') )
									{
										application.model.Util.cfdump( carrierResponse.Account.AlpPlanInfo.deviceCapList );
										
										if ( ArrayLen(carrierResponse.Account.AlpPlanInfo.deviceCapList) )
										{
											result.DeviceCap = carrierResponse.Account.AlpPlanInfo.deviceCapList[1].Cap;
											result.DeviceCapUsed = carrierResponse.Account.AlpPlanInfo.deviceCapList[1].Used;
										}
										
									}

									if ( carrierResponse.Account.LineInfo.PlanInfo.PlanType eq 'IN' )
									{
										result.WirelessLineType = 'individual';
									}
									else
									{
										result.WirelessLineType = 'family';
									}

									//data to support commission codes
									
									if ( carrierResponse.Account.LineInfo.PlanInfo.PlanType eq 'FP' )
									{
										result.IsPrimaryLine = true;
									}
									else
									{
										result.IsPrimaryLine = false; //FS, IN & ALP cannot be a primary line
									}
									
									result.ExistingLineMonthlyCharges = carrierResponse.Account.LineInfo.PlanInfo.PlanPrice;
									result.ExistingAccountMonthlyCharges = 0;
									
									if ( carrierResponse.Account.PlanType eq 'IN' )
									{
										result.WirelessAccountType = 'individual';
									}
									else
									{
										result.WirelessAccountType = 'family';
									}
									
									
								}
								else
								{
									local.myResponse.setResultCode('CL002');
									local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.ErrorCode );
								}

								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('CL010');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('CL010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('CL010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('CL011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('CL011');
								break;
							}
							
						}

						local.myResponse.setResult( result );
					</cfscript>

                    <cfreturn local.myResponse />

                </cfcase>

                <cfcase value="109"> <!--- att --->

					<cfscript>
						requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
						requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
						requestHeader.setReferenceNumber( local.referenceNumber );
						requestHeader.setConversationId( arguments.CarrierConversationId );
						
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
						customerLookupRequest.setBillingZip( local.zipCode );
						customerLookupRequest.setMsiSdn( local.mdn );
						customerLookupRequest.setNumberOfLines( arguments.NumberOfLinesRequested );
						customerLookupRequest.setPin( local.pin );
						
						serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
						serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
						serviceBusRequest.setAction( 'CustomerLookup' );
						serviceBusRequest.setRequestData( customerLookupRequest );
						
						serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
						
						//application.model.Util.cfdump( serviceBusReponse );
						//application.model.Util.cfabort();
						
						switch( serviceBusReponse.ResponseStatus.ErrorCode )
						{
							case '0':
							{
								local.myResponse.setResultCode('CL001');
								local.hasMatchingLine = false;
								carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
	
								if ( carrierResponse.ResponseStatus.ErrorCode eq '00000' )
								{
									customerPhoneLines = carrierResponse.CustomerInquiryLines;
									result.CarrierConversationId = carrierResponse.ConversationId;			
									
									for (i = 1; i <= ArrayLen(customerPhoneLines); i++)
									{
										if ( customerPhoneLines[i].Mdn eq local.mdn )
										{
											local.hasMatchingLine = true;
											
											result.User = createobject('component','cfc.model.User').init();
											result.User.setFirstName('');
											result.User.setLastName('');
											
											//Account level data
											result.User.setLinesApproved( carrierResponse.LinesAvailable ); //Lines Approved minus lines active
											result.User.setLinesActive( carrierResponse.LinesActive );
                                  			result.CustomerAccountNumber = carrierResponse.CustomerAccountNumber;
											result.CustomerAccountPassword = carrierResponse.CustomerAccountPassword;
											
                                            //Line level data
                                            result.CanUpgradeEquipment = customerPhoneLines[i].EquipmentUpgradeAvailable;
                                            result.CurrentImei = '';
                                            
                                            if ( StructKeyExists( customerPhoneLines[i], 'UpgradeAvailableDate') )
                                            {
                                            	result.EquipmentUpgradeEligibilityDate = customerPhoneLines[i].UpgradeAvailableDate;
                                            }
                                            else
                                            {
                                            	result.EquipmentUpgradeEligibilityDate = '';
                                            }
											
                                            //Data/code to support commission codes
											result.ExistingAccountMonthlyCharges = carrierResponse.ExistingAccountMonthlyCharges;
											result.IsPrimaryLine = customerPhoneLines[i].IsPrimaryLine;
                                            result.ExistingLineMonthlyCharges = customerPhoneLines[i].ExistingLineMonthlyCharges;
                                           	result.WirelessLineType = customerPhoneLines[i].WirelessLineType;
											result.WirelessAccountType = carrierResponse.WirelessAccountType;
											result.CarrierPlanType = '';
											result.CarrierPlanId = '';

											break;
										}
									}									
									
									if ( !local.hasMatchingLine )
									{
                             			local.myResponse.setResultCode('CL002');
                    					result = {};
									}
									
								}
								else
								{
									local.myResponse.setResultCode('CL002');
									local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.ErrorCode );
								}

								break;
							}
							case 'RequestExecutionFailure':
							{
								local.myResponse.setResultCode('CL010');
								local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
								break;
							}
							case 'HeaderValidationFailure':
							{
								local.myResponse.setResultCode('CL010');
								break;
							}
							case 'RequestValidationFailure':
							{
								local.myResponse.setResultCode('CL010');
								break;
							}
							case 'CommunicationFailure':
							{
								local.myResponse.setResultCode('CL011');
								break;
							}																								
							default:
							{
								local.myResponse.setResultCode('CL011');
								break;
							}
						}

						local.myResponse.setResult( result );
					</cfscript>

                    <cfreturn local.myResponse />
                </cfcase>

                <cfcase value="128"> <!--- TMOBILE --->

            		<!--- invoke the request --->
                    <cfinvoke
                         webservice="#request.config.TMobileEndPoint#&dd=5"
                         method="CustomerLookupByMsiSdn"
                         returnvariable="resCustomerLookupByMDN">
                            <cfinvokeargument name="msiSdn" value="#local.mdn#" />
                            <cfinvokeargument name="pin" value="#local.pin#" />
                            <cfinvokeargument name="ReferenceNumber" value="#local.referenceNumber#" />
                    </cfinvoke>
                    <!--- end invokling the request --->

                    <!--- handle the response --->
                    <cfif resCustomerLookupByMDN.getErrorCode() eq 0> <!--- success --->
                    	<cfswitch expression="#resCustomerLookupByMDN.getServiceResponseSubCode()#">
                        	<cfcase value="400"> <!--- customer found --->
                        		<!--- Customer found in carrier. --->
								<cfset local.myResponse.setResultCode("CL001") />

                               	<!--- get the initial line --->
                                <cfset local.inqueryLines = resCustomerLookupByMDN.getCustomerInquiryLines() />
                               	<cfset local.lines = local.inqueryLines.getCustomerInquiryLine() />

                                <!--- Loop lines until the mdn passed in equals the mdn for the line --->
                                <cfset local.hasMatchingLine = false />
                                <cfloop from="1" to="#ArrayLen(local.lines)#" index="local.i">
									<cfif local.lines[1].getMDN() eq local.mdn or ArrayLen(local.lines) eq 1>
                                    	<cfset local.hasMatchingLine = true />
                                        <!--- build the customer data --->
                                            <!--- TODO: build general customer data --->
                                            <cfset local.result.User = createobject('component','cfc.model.User').init() />
                                            <cfset local.result.User.setFirstName("") />
                                            <cfset local.result.User.setLastName("") />

											<!--- account level data --->
                                            <cfset local.result.User.setLinesApproved(resCustomerLookupByMDN.getLinesAvailable()) />
											<cfset local.result.User.setLinesActive(resCustomerLookupByMDN.getLinesActive()) />
                                            <cfset local.result.CustomerAccountNumber = resCustomerLookupByMDN.getCustomerAccountNumber() />

                                            <!--- line level data --->
                                            <cfset local.result.CanUpgradeEquipment = local.lines[local.i].isEquipmentUpgradeAvailable() />
											<cfset local.result.CurrentImei = '' />
											
											<!--- Feild is not always passed back --->
											<cftry>
												<cfset local.result.EquipmentUpgradeEligibilityDate = local.lines[local.i].getUpgradeAvailableDate() />

												<cfcatch>
													<cfset local.result.EquipmentUpgradeEligibilityDate = ''/>
												</cfcatch>
											</cftry>

                                            <!--- data/code to support commission codes --->
											<cfset local.result.IsPrimaryLine = local.lines[local.i].isIsPrimaryLine() />
                                            <cfset local.result.ExistingLineMonthlyCharges = local.lines[local.i].getExistingLineMonthlyCharges() />
                                            <cfset local.result.WirelessLineType = local.lines[local.i].getWirelessLineType().getValue() />
                                            <cfset local.result.WirelessAccountType = resCustomerLookupByMDN.getWirelessAccountType().getValue() />
											<cfset local.result.ExistingAccountMonthlyCharges = resCustomerLookupByMDN.getExistingAccountMonthlyCharges() />
											<cfset local.result.CarrierPlanType = '' />
											<cfset local.result.CarrierPlanId = '' />

                                            <!--- TODO: build the customer billing address --->
                                            <cfset local.myBillingAddress = createobject('component','cfc.model.Address').init() />
                                            <cfset local.result.User.setBillingAddress(local.myBillingAddress) />

                                            <!--- Shipping address --->
                                            <!--- TODO: add shipping address --->

                                            <cfset local.myResponse.setResult(local.result) />
                                        <!--- end building customer data --->




                                        <cfbreak /> <!--- we have a match, jump out --->
                                    </cfif>
                                </cfloop>
                                <cfif not local.hasMatchingLine> <!---not found --->
                                	<cfset local.myResponse.setResultCode("CL002") />
                    				<cfset local.result = {} />
                                </cfif>


                        	</cfcase>
                            <cfcase value="402"> <!--- not found --->
                            	<cfset local.myResponse.setResultCode("CL003") />
                    			<cfset local.result = {} />
                            </cfcase>

                        	<cfcase value="401"> <!--- not found --->
                            	<cfset local.myResponse.setResultCode("CL002") />
                    			<cfset local.result = {} />
                            </cfcase>
                            <cfdefaultcase>
                            	 <!--- Invalid / unknown Request --->
								<cfset local.myResponse.setResultCode("CL010") />
                            	<cfset local.result = {} />
                            </cfdefaultcase>
                        </cfswitch>
                    <cfelseif resCustomerLookupByMDN.getErrorCode() eq 2> <!--- timeout --->
                    	<cfset local.myResponse.setResultCode("CL012") />
                    	<cfset local.result = {} />

                    <cfelse> <!--- Failure --->

                        <!--- Invalid Request --->
						<cfset local.myResponse.setResultCode("CL010") />
                        <cfset local.result = {} />
                    </cfif>
                    <!--- end handle the response --->

                    <cfreturn local.myResponse />
                </cfcase>
                <cfcase value="299"> <!--- sprint --->

					<cfscript>
						local.sprintOrderType = '';
						
						switch ( arguments.ActivationType )
						{
							case 'new':
							{
								local.sprintOrderType = 'NEW';
								break;
							}
							case 'upgrade':
							{
								local.sprintOrderType = 'UPGRADE';
								break;
							}					
							case 'addaline':
							{
								local.sprintOrderType = 'ADD_ON';
								break;
							}		
							default:
							{
								local.sprintOrderType = 'NEW';
								break;
							}
						}
					</cfscript>

            		<!--- invoke the request --->
                    <cfinvoke
                         webservice="#request.config.SprintEndPoint#"
                         method="CustomerLookupByMDN"
                         returnvariable="resCustomerLookupByMDN">
                            <cfinvokeargument name="MDN" value="#local.mdn#" />
                            <cfinvokeargument name="SecretKey" value="#local.pin#" />
							<cfinvokeargument name="SSN" value="#local.LastFourSsn#" />
							<cfinvokeargument name="QuestionAnswer" value="#local.SecurityQuestionAnswer#" />
							<cfinvokeargument name="ReferenceNumber" value="#local.referenceNumber#" />
                            <cfinvokeargument name="OrderType" value="#local.sprintOrderType#" />
                    </cfinvoke>

					<!--- handle the response --->
                    <cfif resCustomerLookupByMDN.getErrorCode() eq 0> <!--- success --->
                    	<cfswitch expression="#resCustomerLookupByMDN.getServiceResponseSubCode()#">
                        	<cfcase value="400"> <!--- customer found --->
                        		<!--- Customer found in carrier. --->
								<cfset local.myResponse.setResultCode("CL001") />
                               	<!--- get the initial line --->
                                <cfset local.inqueryLines = resCustomerLookupByMDN.getCustomerInquiryLines() />
                               	<cfset local.lines = local.inqueryLines.getCustomerInquiryLine() />

                                <!--- Loop lines until the mdn passed in equals the mdn for the line --->
                                <cfset local.hasMatchingLine = false />
                                <cfloop from="1" to="#ArrayLen(local.lines)#" index="local.i">

									<cfif trim(local.lines[local.i].getMDN()) eq trim(local.mdn) or ArrayLen(local.lines) eq 1>

                                		<cfset local.hasMatchingLine = true />
                                    	<!--- build the customer data --->
                                        <!--- TODO: build general customer data --->
                                        <cfset local.result.User = createobject('component','cfc.model.User').init() />
                                        <cfset local.result.User.setFirstName("") />
                                        <cfset local.result.User.setLastName("") />

										<!--- account level data --->
                                        <cfset local.result.User.setLinesApproved(resCustomerLookupByMDN.getLinesAvailable()) />
										<cfset local.result.User.setLinesActive(resCustomerLookupByMDN.getLinesActive()) />
                                        <cfset local.result.CustomerAccountNumber = resCustomerLookupByMDN.getCustomerAccountNumber() />

                                        <!--- line level data --->
                                        <cfset local.result.CanUpgradeEquipment = local.lines[local.i].isEquipmentUpgradeAvailable() />
										<cfset local.result.EquipmentUpgradeEligibilityDate = local.lines[local.i].getUpgradeAvailableDate() />
										<cfset local.result.CarrierPlanId = local.lines[local.i].getPlanCode() />
										<cfset local.result.CurrentImei = local.lines[local.i].getCurrentImei() />

                                        <!--- data/code to support commission codes --->
										<cfset local.result.IsPrimaryLine = local.lines[local.i].isIsPrimaryLine() />
                                        <cfset local.result.ExistingLineMonthlyCharges = local.lines[local.i].getExistingLineMonthlyCharges() />
                                        <cfset local.result.WirelessLineType = local.lines[local.i].getWirelessLineType().getValue() />
                                        <cfset local.result.WirelessAccountType = resCustomerLookupByMDN.getWirelessAccountType().getValue() />
										<cfset local.result.ExistingAccountMonthlyCharges = resCustomerLookupByMDN.getExistingAccountMonthlyCharges() />
										<cfset local.result.CarrierPlanType = '' />
										
										<!--- Customer login data --->
										<cfset local.result.SecretKey = '' />
										<cfset local.result.SSN = '' />
										<cfset local.result.QuestionAnswer = '' />

                                        <!--- TODO: build the customer billing address --->
                                        <cfset local.myBillingAddress = createobject('component','cfc.model.Address').init() />
                                        <cfset local.result.User.setBillingAddress(local.myBillingAddress) />

                                        <!--- Shipping address --->
                                        <!--- TODO: add shipping address --->

                                        <cfset local.myResponse.setResult(local.result) />
                                        <!--- end building customer data --->

                                      </cfif>
                                </cfloop>

                                <cfif not local.hasMatchingLine> <!---not found --->
                                	<cfset local.myResponse.setResultCode("CL002") />
                    				<cfset local.result = {} />
                                </cfif>

                        	</cfcase>
                        	
                            <cfcase value="402"> <!--- not found --->
                            	<cfset local.myResponse.setResultCode("CL003") />
                    			<cfset local.result = {} />
                            </cfcase>
                            
                        	<cfcase value="401"> <!--- not found --->
                            	<cfset local.myResponse.setResultCode("CL002") />
                    			<cfset local.result = {} />
                            </cfcase>

                        	<cfcase value="404"> <!--- Account Locked --->
                            	<cfset local.myResponse.setResultCode("CL002") />
								<cfset local.myResponse.setErrorCode('404') />
								<cfset local.myResponse.setErrorMessage( resCustomerLookupByMDN.getPrimaryErrorMessage() ) />
                    			<cfset local.result = {} />
                            </cfcase>

                        	<cfcase value="406"> <!---  Account look up credentials invalid --->
                            	<cfset local.myResponse.setResultCode("CL002") />
								<cfset local.myResponse.setErrorCode('406') />
								<cfset local.myResponse.setErrorMessage( resCustomerLookupByMDN.getPrimaryErrorMessage() ) />
                    			<cfset local.result = {} />
                            </cfcase>
                            
                            <cfcase value="307"> <!--- Customer account is delinquent --->
                            	<cfset local.myResponse.setResultCode("CL004") />
                    			<cfset local.result = {} />
                            </cfcase>
                                                   
                            <cfdefaultcase>
                            	 <!--- Invalid / unknown Request --->

								<cfset local.myResponse.setResultCode("CL010") />
                            	<cfset local.result = {} />
                            </cfdefaultcase>
                        </cfswitch>
                    <cfelseif resCustomerLookupByMDN.getErrorCode() eq 2> <!--- timeout --->
                    	<cfset local.myResponse.setResultCode("CL012") />
                    	<cfset local.result = {} />

                    <cfelse> <!--- Failure --->

                        <!--- Invalid Request --->
						<cfset local.myResponse.setResultCode("CL010") />
                        <cfset local.result = {} />
                    </cfif>
                    <!--- end handle the response --->

                    <cfreturn local.myResponse />
                </cfcase>
           	</cfswitch>


        <cfelse>

            <!--- else return test data in Reponse object based on the resultCode passed --->
            <cfset local.myResponse = createobject('component','cfc.model.Response').init() />

        	<cfswitch expression="#local.resultCode#">
				<cfcase value="CL001|CL001-B|CL001-C|CL001-D|CL001-E" delimiters="|">
                	<!--- Customer found in carrier. --->
                    <cfset local.myResponse.setResultCode("CL001") />

                    <!--- build the customer data --->
                    	<!--- TODO: build general customer data --->
                        <cfset local.result.User = createobject('component','cfc.model.User').init() />
                        <cfset local.result.User.setFirstName("Jane") />
                        <cfset local.result.User.setLastName("Doe") />
						<cfset local.result.User.setLinesActive( 1 ) />
						
                        <cfif local.resultCode EQ "CL001-B">
                       		<cfset local.result.User.setLinesApproved(0) />
                       	<cfelse>
                       		<cfset local.result.User.setLinesApproved(4) />
						</cfif>
						<cfif local.resultCode EQ "CL001-C">
                       		<cfset local.result.CanUpgradeEquipment = false />
							<cfset local.result.EquipmentUpgradeEligibilityDate = '' />
                       	<cfelse>
                       		<cfset local.result.CanUpgradeEquipment = true />
						</cfif>
                        <cfset local.result.CustomerAccountNumber = "StubbedAccountNumber" />
						<cfset local.result.CustomerAccountPassword = "" />

                    	<!--- TODO: build the customer billing address --->
                        <cfset local.myBillingAddress = createobject('component','cfc.model.Address').init() />
                        <cfset local.myBillingAddress.setAddressLine1("1056 Summit Ave E") />
                        <cfset local.myBillingAddress.setAddressLine2("##456") />
                        <cfset local.myBillingAddress.setCity("Seattle") />
                        <cfset local.myBillingAddress.setState("WA") />
                        <cfset local.myBillingAddress.setZipCode("98102") />
                        <cfset local.result.User.setBillingAddress(local.myBillingAddress) />

                        <!--- TODO: build the customer shipping address --->
                        <cfset local.myShippingAddress = createobject('component','cfc.model.Address').init() />
                        <cfset local.myShippingAddress.setAddressLine1("783 45th Ave N.") />
                        <cfset local.myShippingAddress.setAddressLine2("") />
                        <cfset local.myShippingAddress.setCity("Seattle") />
                        <cfset local.myShippingAddress.setState("WA") />
                        <cfset local.myShippingAddress.setZipCode("98188") />
                        <cfset local.result.User.setShippingAddress(local.myShippingAddress) />

                        <cfset local.result.ExistingAccountMonthlyCharges = 0.00 />
						<cfset local.result.IsPrimaryLine = true />
                        <cfset local.result.ExistingLineMonthlyCharges = 59.95 />
                        <cfset local.result.WirelessLineType = 1 />
						<cfset local.result.CarrierPlanType = '' />
						<cfset local.result.CarrierPlanId = '' />

                        <cfif local.resultCode EQ "CL001-D">
							<cfset local.result.WirelessAccountType = "Individual" />
						<cfelse>
							<cfset local.result.WirelessAccountType = "Family" />
						</cfif>

                        <cfif local.resultCode EQ "CL001-E">
					   		<cfset session.InvalidAccountPasswordAttempts = 0 />
							<cfset local.result.CustomerAccountPassword = "9876" />
						</cfif>

    					<cfif local.carrier eq 42>
							<cfset local.result.DeviceCap = 10 />
							<cfset local.result.DeviceCapUsed = 5 />
							<cfset local.result.DeviceFamily = 'Phone,Tablet Internet Home' />
						</cfif>
						
    					<cfif local.carrier eq 109>
							<cfset local.result.CarrierConversationId = '' />
						</cfif>						
						
						<cfset local.result.CurrentImei = '' />
    
                        <cfset local.myResponse.setResult(local.result) />

                	<!--- end building customer data --->
                </cfcase>

                <cfcase value="CL002">
                	<!--- Customer not found in carrier. --->
                    <cfset local.myResponse.setResultCode("CL002") />
                    <cfset local.result = {} />
                </cfcase>

                <cfcase value="CL010">
                	<!--- Invalid Request --->
                    <cfset local.myResponse.setResultCode("CL010") />
                    <cfset local.result = {} />
                </cfcase>

                <cfcase value="CL011">
                	<!--- Unable to Connect to Carrier Service --->
                    <cfset local.myResponse.setResultCode("CL011") />
                    <cfset local.result = {} />
                </cfcase>

                <cfcase value="CL012">
                	<!--- Service Timeout --->
                    <cfset local.myResponse.setResultCode("CL012") />
                    <cfset local.result = {} />
                </cfcase>

                <cfdefaultcase>
					<!--- TODO: error code not implemented,  throw exception ---->
                    <cfthrow message="ResultCode passed in is not defined.">
            	</cfdefaultcase>
            </cfswitch>

			<cfreturn local.myResponse />

        </cfif>

    </cffunction>

</cfcomponent>
