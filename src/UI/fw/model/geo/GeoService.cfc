<cfcomponent extends="fw.model.BaseService" output="false">
	
	<cfproperty name="AddressProvider" inject="provider:Address" />
	<cfproperty name="GeoGateway" inject="id:GeoGateway" />
	<cfproperty name="MilitaryBaseGateway" inject="id:MilitaryBaseGateway" />
	<cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" />
	<cfproperty name="AddressValidationService" inject="id:AddressValidationService" />
	
	<cffunction name="newAddress" access="public" output="false" returntype="Address" hint="Returns new Address.">    
    	<cfreturn AddressProvider.get()>
    </cffunction>
    
    <!--- States  --->
	<cffunction name="findStateName" access="public" returntype="string" output="false">
		<cfargument name="abbreviation" required="true" type="string">

		<cfset var qState = variables.GeoGateway.getStateByAbbreviation(arguments.abbreviation)>
		
		<cfif qState.recordCount>
			<cfreturn qState.state>
		<cfelse>
			<cfthrow message="Invalid state abbreviation: #arguments.abbreviation#">
		</cfif>
		
	</cffunction>

	<cffunction name="getAllStates" access="public" returntype="query" output="false">
		<cfreturn variables.GeoGateway.getAllStates()>
	</cffunction>

	<cffunction name="getAllStatesAPO" access="public" returntype="query" output="false">
		<cfreturn variables.GeoGateway.getAllStatesAPO()>
	</cffunction>
	
	<!---- Military Bases --->
	<cffunction name="getAllBases" access="public" returntype="query" output="false">
		<cfreturn variables.MilitaryBaseGateway.getAllBases()>
	</cffunction>
	

	<cffunction name="validateAddress" access="public" returntype="struct" output="false">
		<cfargument name="Address" type="Address" required="true">
		<cfargument name="addressType" type="string" default="Billing">
		<cfargument name="resultCode" type="string" default="">
		<cfscript>
			var rtn = {isSuccess=false, failureMessage="The address provided could not be validated. Please review and resubmit."};
			
			var args = {
					Address = arguments.Address
					,addressType = arguments.addressType
					//,referenceNumber = variables.SessionStorage.getVar('checkout').referenceNumber
					//,validateWithCarrier = variables.SessionStorage.getVar('checkout').carrier
					,resultCode = arguments.resultCode
					//,serviceZipCode = variables.SessionStorage.getVar('cart').getZipCode()
				};
			
			//var Result = variables.AddressValidationService.validateAddress(argumentCollection=args);
			dump(variables.sessionstorage.getvar('checkout'),true);
			switch( Result.getResultCode() ) {
				case "AV001" : {
					rtn.failureMessage = "The address could not be validated, but some alternatives are available. Select an alternative address or review and resubmit your address.";
					break;
				}
				case "AV003" : {
					rtn.isSuccess = true;
					rtn.failureMessage = "";
					break;
				}
				case "AV002" :
				case "AV004" : {
					rtn.failureMessage = "The address provided could not be validated. Please review and resubmit.";
					break;
				}
				case "AV010" :
				case "AV011" :
				case "AV012" : {
					rtn.failureMessage = "Unable to connect to carrier validation service.";
					break;
				}
				case "AV999" : {
					rtn.failureMessage = "Address not permitted.";
					break;
				}
			}
			
			return rtn;
		</cfscript>
	</cffunction>
</cfcomponent>