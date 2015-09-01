<cfcomponent displayname="Carrier" hint="generic carrier component" extends="fw.model.BaseService" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.BaseCarrier">
		<cfreturn this />
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
		For get calls converts args into a query string	
	--->
	<cffunction name="argsList" access="private" returnType="string">

		<cfset var arglist = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfif len(arglist)>
				<cfset arglist = arglist & "&" />
			</cfif>
			<cfset arglist = arglist & #theArg# & "=" & arguments[theArg] />
		</cfloop>		
		
		<cfreturn arglist />
		
	</cffunction>
</cfcomponent>