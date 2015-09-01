<cfcomponent displayname="VzwCarrier" hint="Interface to Vzw Carrier API" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="account" output="false" access="public" returntype="any">
		<cfreturn "" />
	</cffunction>
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->

	<!--- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--->
	<!---<cffunction name="processResults" returnType="fw.model.CarrierApi.Verizon.VzwCarrierResponse" access="private">
		<cfargument name="apiResultString" type="string" required="true" /> 
				
		<cfset var carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.VzwCarrierResponse').init() />
		
		<cfif isJson(arguments.apiResultString)>
			<cfset carrierResponse.setResponse(deserializeJson(arguments.apiResultString,true)) />
			<cfset carrierResponse.setStatus(0) />
		<cfelse>
			<cfset carrierResponse.setStatus(404) />
		</cfif>
		
		<cfreturn carrierResponse />
	
	</cffunction>--->
	
	<!---
		Get the Service URL
	 --->
	<cffunction name="getServiceURL" returnType="string" access="public">
		<cfreturn variables.CarrierServiceURL />
	</cffunction>


	<!---
		For get calls converts args into a query string	
	--->
	<cffunction name="argsList" access="private" returnType="string">
		<cfset var arglist = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif not listFindNocase(arguments.excludedArgsList,theArg) >
				<cfif len(arglist)>
					<cfset arglist = arglist & "&" />
				</cfif>
				<cfset arglist = arglist & theArg & "=" & arguments[theArg] />
			</cfif>
		</cfloop>		
		
	</cffunction>

</cfcomponent>