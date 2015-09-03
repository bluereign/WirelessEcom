<cfcomponent displayname="AttCarrier" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.BaseCarrier" output="false">
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->
	
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<!---<cfhttp url="#variables.CarrierServiceURL#/AttAccount?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>	--->	
		<cfhttp url="#variables.CarrierServiceURL#/Account" method="POST">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#serializeJSON(arguments)#">
		</cfhttp>
		<cfreturn processResults(cfhttp) />	
	</cffunction>
	
	<cffunction name="areaCode" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<cfhttp url="#variables.CarrierServiceURL#/AttAreaCode?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>		
		<cfreturn processResults(cfhttp) />		
	</cffunction>


	<!--- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--->
	<cffunction name="processResults" returnType="fw.model.CarrierApi.Att.AttCarrierResponse" access="private">
		<cfargument type="struct" name="cfhttpResult" required="true" /> 
		<cfset var emptyObj = {} />
				
		<cfset var carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttCarrierResponse').init() />
		<cfset carrierResponse.setHttpStatus(cfhttpResult.statusCode) />
		<cfif isJson(arguments.cfhttpResult.fileContent)>			
			<cfset carrierResponse.setResponse(deserializeJson(arguments.cfhttpResult.fileContent,true)) />
		<cfelse>
			<cfset carrierResponse.setResponse(emptyObj) />
		</cfif>
		
		<!--- if httpStatus is 200 OK status = 0 else more specific case error may be set --->
		
		
		<cfreturn carrierResponse />
	
	</cffunction>

	<!---
		Get the Service URL
	 --->
	<cffunction name="getServiceURL" returnType="string" access="public">
		<cfreturn variables.CarrierServiceURL />
	</cffunction>

</cfcomponent>