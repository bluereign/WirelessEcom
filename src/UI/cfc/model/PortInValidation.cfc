
<cfcomponent output="false" displayname="PortInValidation">

	<cffunction name="init" access="public" returntype="PortInValidation" output="false">
		<cfreturn this />
	</cffunction>

	<!---
		Response codes:
		
			PI001 - Success
			PI002 - Port in denied for 1 or more MDN in list
			PI010 - Invalid Request
			PI011 - Unable to Connect to Carrier Service
			PI012 - Service Timeout
	 --->
	<cffunction name="validate" access="public" returntype="Response" output="false">
		<cfargument name="carrier" type="string" required="true" />
		<cfargument name="mdnList" type="array" required="true" hint="A list of phone number and zipcodes to validate." />
		<cfargument name="referenceNumber" type="string" required="false" />
		<cfargument name="resultCode" type="string" required="false" default="" />
		<cfargument name="ServiceZipCode" type="string" required="false" default="" />
		<cfargument name="CarrierConversationId" type="string" default="" required="false" />

		<cfscript>
			var local = {};
			var requestHeader = '';
			var portInValidationRequest = '';
			var carrierResponse = '';
								
			local.carrier = arguments.carrier;
			local.referenceNumber = arguments.referenceNumber;
			local.mdnList = arguments.mdnList;
			local.resultCode = arguments.resultCode;
		</cfscript>

		<cfif not len(trim(local.resultCode))>
			<cfswitch expression="#trim(local.carrier)#">
				<cfcase value="42"><!--- VERIZON --->
					<cfset local.myResponse = createObject('component', 'Response').init() />
					<cfset local.result.mdnList = arrayNew(1) />
					<cfset local.myResponse.setResultCode('PI001') />
					<cfset local.hasOneMDN = false />
					<cfset local.request.mdnList = structNew() />
					<cfset local.request.mdnList.mdnSet = arrayNew(1) />
					<cfset local.counter = 1 />
					<cfset local.aMdns = [] />

					<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
						<cfif len(local.mdnList[local.i].mdn) gt 0>
							<cfset local.request.mdnList.mdnSet[local.counter] = structNew() />
							<cfset local.request.mdnList.mdnSet[local.counter].mdn = ' ' & local.mdnList[local.i].mdn />
							<cfset local.request.mdnList.mdnSet[local.counter].serviceZipCode = ' ' & local.mdnList[local.i].zip />
							<cfset local.request.mdnList.mdnSet[local.counter].isPortable = false />
							<cfset local.counter = (local.counter + 1) />
							<cfset local.hasOneMDN = true />
							
							<cfset ArrayAppend( local.aMdns, ' ' & local.mdnList[local.i].mdn ) />
						</cfif>
					</cfloop>

					<cfif local.hasOneMDN>

						<cfscript>
							requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
							requestHeader.setServiceAreaZip( Trim(arguments.ServiceZipCode) );
							requestHeader.setReferenceNumber( local.referenceNumber );
							requestHeader.setConversationId( arguments.CarrierConversationId );
							
							portInValidationRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.PortInValidationRequest').init();
							portInValidationRequest.setRequestHeader( requestHeader );
							portInValidationRequest.setServiceAreaZip( arguments.ServiceZipCode );
							portInValidationRequest.setMdns( local.aMdns );
							
							serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
							serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
							serviceBusRequest.setAction( 'PortInValidation' );
							serviceBusRequest.setRequestData( portInValidationRequest );
							
							serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
							
							switch(serviceBusReponse.ResponseStatus.ErrorCode)
							{
								case '0':
								{
									local.myResponse.setResultCode('PI001');
									carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
									local.result.list = carrierResponse.PortInfoList;
									local.result.MdnList = [];
									
									//application.model.Util.cfdump( carrierResponse );
									//application.model.Util.cfdump( local.mdnList );
									
									for (i=1; i <= ArrayLen(local.mdnList); i++)
									{
										local.result.mdnList[i] = {};
										local.result.mdnList[i].mdn = local.mdnList[i].mdn;
										local.result.mdnList[i].areaCode = local.mdnList[i].areaCode;
										local.result.mdnList[i].isPortable = false;
										
										if ( Len(local.mdnList[i].mdn) )
										{
											for (j=1; j <= ArrayLen(local.result.list); j++)
											{
												if ( local.result.list[j].Mdn eq local.mdnList[i].mdn )
												{
													local.result.mdnList[i].mdn = local.mdnList[i].mdn;
													local.result.mdnList[i].isPortable = local.result.list[j].IsPortable;
	
													if ( !local.result.list[j].IsPortable )
													{
														local.myResponse.setResultCode('PI002'); //Unportable MDN found
													}
												}
											}
										}
										else
										{
											local.result.mdnList[i].isPortable = true;
										}
									}
									
									//application.model.Util.cfdump( local.result.MdnList );
									//application.model.Util.cfabort( );
								
									break;
								}
								case 'RequestExecutionFailure':
								{
									local.myResponse.setResultCode('PI002');
									local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
									break;
								}
								case 'HeaderValidationFailure':
								{
									local.myResponse.setResultCode('PI010');
									break;
								}
								case 'RequestValidationFailure':
								{
									local.myResponse.setResultCode('PI010');
									break;
								}
								case 'CommunicationFailure':
								{
									local.myResponse.setResultCode('PI011');
									break;
								}																								
								default:
								{
									local.myResponse.setResultCode('PI011');
									break;
								}
								
							}
						</cfscript>
					<cfelse>
						<cfset local.result.mdnList = local.mdnList />						
					</cfif>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>

				<cfcase value="109"><!--- AT&T --->
					
					<cfscript>
						local.myResponse = CreateObject('component', 'Response').init();
						local.myResponse.setResultCode('PI001');
						
						local.result.mdnList = [];
						local.hasOneMDN = false;
						local.request.mdnList = {};
						local.request.mdnList.mdnSet = [];
						local.counter = 1;
						
						mdnListRequest = [];
						
						//Create reponse list of which MDNs are portable
						for (i=1; i<=ArrayLen(local.mdnList); i++)
						{
							if ( Len(local.mdnList[i].mdn) )
							{
								local.request.mdnList.mdnSet[local.counter] = {};
								local.request.mdnList.mdnSet[local.counter].mdn = local.mdnList[i].mdn;
								local.request.mdnList.mdnSet[local.counter].serviceZipCode = local.mdnList[i].zip;
								local.request.mdnList.mdnSet[local.counter].isPortable = false;
								local.counter++ ;
								local.hasOneMDN = true;

								ArrayAppend(mdnListRequest, ' ' & local.mdnList[i].mdn); //Prepend white space for deserialization CF 8 limitation
							}
						}
						
						
					</cfscript>

					<cfif local.hasOneMDN>

						<cfscript>
							requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
							requestHeader.setServiceAreaZip( arguments.serviceZipCode );
							requestHeader.setReferenceNumber( local.referenceNumber );
							requestHeader.setConversationId( arguments.CarrierConversationId );
	
							portRequest = CreateObject('component', 'cfc.model.carrierservice.Att.InquirePortRequest').init();
							portRequest.setRequestHeader( requestHeader );
							portRequest.setZipCode( arguments.ServiceZipCode );
							portRequest.setMdnList( mdnListRequest );
	
							serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
							serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
							serviceBusRequest.setAction( 'InquirePort' );
							serviceBusRequest.setRequestData( portRequest );
							
							serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
	
							switch(serviceBusReponse.ResponseStatus.ErrorCode)
							{
								case '0':
								{
									local.myResponse.setResultCode('PI001');
									carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
									local.myResponse.result.CarrierConversationId = carrierResponse.ConversationId;	
									
									local.result.list = carrierResponse.MdnList;
									local.result.CarrierConversationId = carrierResponse.ConversationId;
	
									for (i=1; i<=ArrayLen(local.mdnList); i++)
									{
										local.result.mdnList[i] = {};
										local.result.mdnList[i].mdn = local.mdnList[i].mdn;
										local.result.mdnList[i].areaCode = local.mdnList[i].areaCode;
										local.result.mdnList[i].isPortable = false;
										
										if ( Len(local.mdnList[i].mdn) )
										{
											for (j=1; j <= ArrayLen(local.result.list); j++)
											{
												if ( local.result.list[j].Mdn eq local.mdnList[i].mdn )
												{
													local.result.mdnList[i].mdn = local.mdnList[i].mdn;
													local.result.mdnList[i].isPortable = local.result.list[j].IsPortable;
			
													if ( !local.result.list[j].IsPortable )
													{
														local.myResponse.setResultCode('PI002');
													}
												}
											}
										}
										else
										{
											local.result.mdnList[i].isPortable = true;
										}							
									}

/*
						<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
							<cfset local.result.mdnList[local.i] = structNew() />
							<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
							<cfset local.result.mdnList[local.i].areaCode = local.mdnList[local.i].areaCode />
							<cfset local.result.mdnList[local.i].isPortable = false />

							<cfif len(local.mdnList[local.i].mdn) gt 0>
								<cfloop from="1" to="#arrayLen(local.result.list)#" index="local.u">
									<cfif local.result.list[local.u].getMDN() eq local.mdnList[local.i].mdn>
										<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
										<cfset local.result.mdnList[local.i].isPortable = local.result.list[local.u].isIsPortable() />

										<cfif not local.result.list[local.u].isIsPortable()>
											<cfset local.myResponse.setResultCode('PI002') />
										</cfif>
									</cfif>
								</cfloop>
							<cfelse>
								<cfset local.result.mdnList[local.i].isPortable = true />
							</cfif>
						</cfloop>

*/



	
									break;
								}
								case 'RequestExecutionFailure':
								{
									local.myResponse.setResultCode('PI002');
									local.myResponse.setErrorMessage( serviceBusReponse.ResponseStatus.Message );
									break;
								}
								case 'HeaderValidationFailure':
								{
									local.myResponse.setResultCode('PI010');
									break;
								}
								case 'RequestValidationFailure':
								{
									local.myResponse.setResultCode('PI010');
									break;
								}
								case 'CommunicationFailure':
								{
									local.myResponse.setResultCode('PI011');
									break;
								}																								
								default:
								{
									local.myResponse.setResultCode('PI011');
									break;
								}
								
							}
	
							local.myResponse.setResult( local.result );		
							
						</cfscript>

<!---
						<cfinvoke
							webservice="#request.config.attEndPoint#"
							method="validatePortIn"
							returnvariable="resValidatePortIn">
							<cfinvokeargument name="mdnList" value="#local.request.mdnList#" />
							<cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
						</cfinvoke>

						<cfset local.result.list = resValidatePortIn.getMDNSet().getMDNSet() />

						<cfif resValidatePortIn.getErrorCode() eq 0>
							<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
								<cfset local.result.mdnList[local.i] = structNew() />
								<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
								<cfset local.result.mdnList[local.i].areaCode = local.mdnList[local.i].areaCode />
								<cfset local.result.mdnList[local.i].isPortable = false />

								<cfif len(local.mdnList[local.i].mdn) gt 0>
									<cfloop from="1" to="#arrayLen(local.result.list)#" index="local.u">
										<cfif local.result.list[local.u].getMDN() eq local.mdnList[local.i].mdn>
											<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
											<cfset local.result.mdnList[local.i].isPortable = local.result.list[local.u].isIsPortable() />

											<cfif not local.result.list[local.u].isIsPortable()>
												<cfset local.myResponse.setResultCode('PI002') />
											</cfif>
										</cfif>
									</cfloop>
								<cfelse>
									<cfset local.result.mdnList[local.i].isPortable = true />
								</cfif>
							</cfloop>
						<cfelse>
							<cfset local.myResponse.setResultCode('PI012') />
							<cfset local.result = {} />
						</cfif>
					<cfelse>
						<cfset local.result.mdnList = local.mdnList />
					</cfif>

					
--->

					<cfelse>
						<cfset local.result.mdnList = local.mdnList />
						<cfset local.myResponse.setResult(local.result) />
					</cfif>

					<cfreturn local.myResponse />
				</cfcase>

				<cfcase value="128"><!--- T-Mobile --->
					<cfset local.myResponse = createObject('component', 'Response').init() />
					<cfset local.result.mdnList = arrayNew(1) />

					<cftry>
						<cfset local.myResponse.setResultCode('PI001') />
						<cfset local.hasOneMDN = false />
						<cfset local.request.mdnList= structNew() />
						<cfset local.request.mdnList.mdnSet = arrayNew(1) />
						<cfset local.counter = 1 />

						<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
							<cfif len(local.mdnList[local.i].mdn) gt 0>
								<cfset local.request.mdnList.mdnSet[local.counter] = structNew() />
								<cfset local.request.mdnList.mdnSet[local.counter].mdn = local.mdnList[local.i].mdn />
								<cfset local.request.mdnList.mdnSet[local.counter].serviceZipCode = local.mdnList[local.i].zip />
								<cfset local.request.mdnList.mdnSet[local.counter].isPortable = false />
								<cfset local.counter = (local.counter + 1) />
								<cfset local.hasOneMDN = true />
							</cfif>
						</cfloop>

						<cfif local.hasOneMDN>
							<cfinvoke
                                 webservice="#request.config.tMobileEndPoint#&edfds=5"
                                 method="validatePortIn"
                                 returnvariable="resValidatePortIn">
                                    <cfinvokeargument name="mdnList" value="#local.request.mdnList#" />
                                    <cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
                            </cfinvoke>

							<cfset local.result.list = resValidatePortIn.getMDNSet().getMDNSet() />

							<cfif resValidatePortIn.getErrorCode() eq 0>
								<cfset local.result.list = resValidatePortIn.getMDNSet().getMDNSet() />

								<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
									<cfset local.result.mdnList[local.i] = structNew() />
									<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
									<cfset local.result.mdnList[local.i].areaCode = local.mdnList[local.i].areaCode />
									<cfset local.result.mdnList[local.i].isPortable = false />

									<cfif len(local.mdnList[local.i].mdn) gt 0>
										<cfloop from="1" to="#arrayLen(local.result.list)#" index="local.u">
											<cfif local.result.list[local.u].getMDN() eq local.mdnList[local.i].mdn>
												<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
												<cfset local.result.mdnList[local.i].isPortable = local.result.list[local.u].isIsPortable() />

												<cfif not local.result.list[local.u].isIsPortable()>
													<cfset local.myResponse.setResultCode('PI002') />
												</cfif>
											</cfif>
										</cfloop>
									<cfelse>
										<cfset local.result.mdnList[local.i].isPortable = true />
									</cfif>
								</cfloop>
							<cfelse>
								<cfset local.myResponse.setResultCode('PI012') />
								<cfset local.result = {} />
							</cfif>
						<cfelse>
							<cfset local.result.mdnList = local.mdnList />
						</cfif>

						<cfcatch type="any">
							<cfset local.myResponse.setResultCode('PI013') />
							<cfset local.result = {} />
						</cfcatch>
					</cftry>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>


                
				<cfcase value="299"><!--- Sprint--->
					<cfset local.myResponse = createObject('component', 'Response').init() />
					<cfset local.result.mdnList = arrayNew(1) />

					<cftry>
						<cfset local.myResponse.setResultCode('PI001') />
						<cfset local.hasOneMDN = false />
						<cfset local.request.mdnList= structNew() />
						<cfset local.request.mdnList.mdnSet = arrayNew(1) />
						<cfset local.counter = 1 />

						<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
							<cfif len(local.mdnList[local.i].mdn) gt 0>
								<cfset local.request.mdnList.mdnSet[local.counter] = structNew() />
								<cfset local.request.mdnList.mdnSet[local.counter].mdn = local.mdnList[local.i].mdn />
								<cfset local.request.mdnList.mdnSet[local.counter].serviceZipCode = local.mdnList[local.i].zip />
								<cfset local.request.mdnList.mdnSet[local.counter].isPortable = false />
								<cfset local.counter = (local.counter + 1) />
								<cfset local.hasOneMDN = true />
							</cfif>
						</cfloop>

						<cfif local.hasOneMDN>
							<cfinvoke
                                 webservice="#request.config.sprintEndPoint#"
                                 method="validatePortIn"
                                 returnvariable="resValidatePortIn">
                                    <cfinvokeargument name="mdnList" value="#local.request.mdnList#" />
                                    <cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
                            </cfinvoke>

							<cfset local.result.list = resValidatePortIn.getMDNSet().getMDNSet() />

							<cfif resValidatePortIn.getErrorCode() eq 0>
								<cfset local.result.list = resValidatePortIn.getMDNSet().getMDNSet() />

								<cfloop from="1" to="#arrayLen(local.mdnList)#" index="local.i">
									<cfset local.result.mdnList[local.i] = structNew() />
									<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
									<cfset local.result.mdnList[local.i].areaCode = local.mdnList[local.i].areaCode />
									<cfset local.result.mdnList[local.i].isPortable = false />

									<cfif len(local.mdnList[local.i].mdn) gt 0>
										<cfloop from="1" to="#arrayLen(local.result.list)#" index="local.u">
											<cfif local.result.list[local.u].getMDN() eq local.mdnList[local.i].mdn>
												<cfset local.result.mdnList[local.i].mdn = local.mdnList[local.i].mdn />
												<cfset local.result.mdnList[local.i].isPortable = local.result.list[local.u].isIsPortable() />

												<cfif not local.result.list[local.u].isIsPortable()>
													<cfset local.myResponse.setResultCode('PI002') />
												</cfif>
											</cfif>
										</cfloop>
									<cfelse>
										<cfset local.result.mdnList[local.i].isPortable = true />
									</cfif>
								</cfloop>
							<cfelse>
								<cfset local.myResponse.setResultCode('PI012') />
								<cfset local.result = {} />
							</cfif>
						<cfelse>
							<cfset local.result.mdnList = local.mdnList />
						</cfif>

						<cfcatch type="any">
							<cfset local.myResponse.setResultCode('PI013') />
							<cfset local.result = {} />
						</cfcatch>
					</cftry>

					<cfset local.myResponse.setResult(local.result) />

					<cfreturn local.myResponse />
				</cfcase>

				<cfdefaultcase>
					<cfthrow message="Invalid carrier code on Port-in validation. Carrier code: #local.carrier# | Line count: #session.cart.getLines()# | Reference number: #local.referenceNumber#" />
				</cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfset local.myResponse = createObject('component', 'Response').init() />
			<cfset local.result.mdnList = arrayNew(1) />
			<cfset local.counter = 1 />

			<cfloop array="#local.mdnList#" index="i">
				<cfset local.listItem = structNew() />
				<cfset local.listItem.mdn = i.mdn />
				<cfset local.listItem.areaCode = i.areaCode />
				<cfset local.listItem.isPortable = false />
				<cfset local.result.mdnList[local.counter] = local.listItem />
				<cfset local.counter = (local.counter + 1) />
			</cfloop>

			<cfswitch expression="#local.resultCode#">
				<cfcase value="PI001">
					<cfset local.myResponse.setResultCode('PI001') />
					<cfset local.counter = 1 />

					<cfloop array="#local.result.mdnList#" index="i">
						<cfset local.result.mdnList[local.counter].isPortable = true />
						<cfset local.counter = (local.counter + 1) />
					</cfloop>
				</cfcase>

				<cfcase value="PI002">
					<!---
					**
					* Port in denied for 1 or more MDN in list.
					**
					--->
					<cfset local.myResponse.setResultCode('PI002') />

					<cfset local.counter = 1 />

					<cfloop array="#local.result.mdnList#" index="i">
						<cfif local.counter eq 1>
							<cfset local.result.mdnList[local.counter].isPortable = false />
						<cfelse>
							<cfset local.result.mdnList[local.counter].isPortable = true />
						</cfif>

						<cfset local.counter = (local.counter + 1) />
					</cfloop>
				</cfcase>

				<cfcase value="PI010">
					<!--- Invalid Request --->
					<cfset local.myResponse.setResultCode('PI010') />
					<cfset local.result = {} />
				</cfcase>

				<cfcase value="PI011">
					<!--- Unable to Connect to Carrier Service --->
					<cfset local.myResponse.setResultCode('PI011') />
					<cfset local.result = {} />
				</cfcase>

				<cfcase value="PI012">
					<!--- Service Timeout --->
					<cfset local.myResponse.setResultCode('PI012') />
					<cfset local.result = {} />
				</cfcase>

				<cfdefaultcase>
					<cfthrow message="ResultCode passed in is not defined." />
				</cfdefaultcase>
			</cfswitch>

			<cfset local.myResponse.setResult(local.result) />

			<cfreturn local.myResponse />
		</cfif>
	</cffunction>
</cfcomponent>