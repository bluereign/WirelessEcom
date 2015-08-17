<cfcomponent displayname="NPALookup" output="false">

	<cffunction name="init" access="public" output="false" returntype="NPALookup">
		<cfreturn this />
	</cffunction>

	<cffunction name="lookup" access="public" output="false" returntype="struct">
		<cfargument name="ZipCode" type="string" required="true" />
		<cfargument name="CarrierId" type="numeric" required="true" />
		<cfargument name="ReferenceNumber" type="string" required="true" />
		<cfargument name="CarrierConversationId" type="string" default="" required="false" />

		<cfscript>
			var local = {};
			var requestHeader = '';
			var npaNxxRequest = '';
			var carrierResponse = '';
			var serviceBusRequest = '';
			var npaLookupResponse = {};
			
			local.zipcode = trim(arguments.zipcode);
			local.referenceNumber = trim(arguments.referenceNumber);
			local.npaList = [];
		</cfscript>

		<cfswitch expression="#carrierId#">
			<cfcase value="109"><!--- ATT --->

				<cfscript>
					requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.AttRequestHeader );
					requestHeader.setServiceAreaZip( local.zipcode );
					requestHeader.setReferenceNumber( local.referenceNumber );
					requestHeader.setConversationId( arguments.CarrierConversationId );
					
					npaNxxRequest = CreateObject('component', 'cfc.model.carrierservice.Att.NpaNxxRequest').init();
					npaNxxRequest.setRequestHeader( requestHeader );
					npaNxxRequest.setZipCode( local.zipcode );
					npaNxxRequest.setMethod( 'ZIP' ); //TODO: find out what value is expected
					
					serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
					serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.ATT );
					serviceBusRequest.setAction( 'NpaNxxLookup' );
					serviceBusRequest.setRequestData( npaNxxRequest );
					
					serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
					
					if (serviceBusReponse.ResponseStatus.ErrorCode eq 0)
					{
						carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );						
						npaLookupResponse.CarrierConversationId = carrierResponse.ConversationId;
					}
				</cfscript>
			</cfcase>
			
			<cfcase value="42"><!--- Verizon --->
				<cfscript>
					requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
					requestHeader.setServiceAreaZip( local.zipcode );
					requestHeader.setReferenceNumber( local.referenceNumber );
					
					npaNxxRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.NpaNxxRequest').init();
					npaNxxRequest.setRequestHeader( requestHeader );
					npaNxxRequest.setZipCode( local.zipcode );
					
					serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
					serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
					serviceBusRequest.setAction( 'NpaNxxLookup' );
					serviceBusRequest.setRequestData( npaNxxRequest );
					
					serviceBusReponse = application.model.RouteService.Route( serviceBusRequest );
					
					if (serviceBusReponse.ResponseStatus.ErrorCode eq 0)
					{
						carrierResponse = deserializeJSON( serviceBusReponse.ResponseData );
					}
				</cfscript>
			</cfcase>
			<cfcase value="128"><!--- T-Mobile --->
				<cfinvoke webservice="#request.config.tmobileEndPoint#" method="NpaLookupByZip" returnvariable="local.resNpaLookupByZip">
					<cfinvokeargument name="zipcode" value="#local.zipcode#" />
					<cfinvokeargument name="referenceNumber" value="#local.referenceNumber#" />
				</cfinvoke>
			</cfcase>
			<cfcase value="299,81"><!--- Sprint & Boost --->
				<cfinvoke webservice="#request.config.sprintEndPoint#" method="NpaNxx" returnvariable="local.resNpaLookupByZip">
					<cfinvokeargument name="zipcode" value="#local.zipcode#" />
					<cfinvokeargument name="referenceNumber" value="#local.referenceNumber#" />
				</cfinvoke>
			</cfcase>

			<cfdefaultcase>
				<cfthrow message="Invalid carrier code. Options are 'Verizon, ATT, T-Mobile, Sprint' The carrier code was '#local.carrier#'." />
			</cfdefaultcase>
		</cfswitch>

		<cfset local.hasResults = false />

		<cfif arguments.carrierId eq 42 || arguments.carrierId eq 109>
			<cfif serviceBusReponse.ResponseStatus.ErrorCode eq 0>
				<cfset local.npaList = [] />
				
				<cfloop array="#carrierResponse.NpaSet#" index="i">
					<cfset ArrayAppend( local.npaList, i.NpaNxx ) />
				</cfloop>
			</cfif>
		<cfelse>
			
			<cftry>
				<cfset local.resNpaLookupByZip.getNPASet().getNpaInfo() />
				<cfset local.hasResults = true />
				<cfcatch type="any">
					<!--- Do Nothing --->
				</cfcatch>
			</cftry>
			
			<cfif local.hasResults>
				<cfset local.resultList = local.resNpaLookupByZip.getNPASet().getNpaInfo() />

				<cfif structKeyExists(local, 'resultList')>
					<cfloop from="1" to="#arrayLen(local.resultList)#" index="local.i">
						<cfset local.npaInfo = local.resNpaLookupByZip.getNPASet().getNpaInfo(local.i - 1) />
						<cfset local.NPAList[local.i] = local.npaInfo.getNpa() />
					</cfloop>
				</cfif>
			</cfif>
		</cfif>


		<cfif not arrayLen(local.npaList)>
			<cfset local.npaList[1] = '000' />
		</cfif>
		
		<cfif arguments.carrierId eq 128 || arguments.carrierId eq 299>
			<!--- Create a set of unique area codes --->
			<cfset local.myHashSet = createObject('java', 'java.util.HashSet') />
			<cfset local.myHashSet.init( local.npaList ) />
			<cfset local.npaList = local.myHashSet.toArray() />
		</cfif>
		
		<cfset npaLookupResponse.npaList = local.npaList />

		<cfreturn npaLookupResponse />
	</cffunction>
</cfcomponent>