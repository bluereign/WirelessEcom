<cfcomponent displayname="AttCarrier" hint="Interface to ATT Carrier API" extends="fw.model.BaseService" output="false">
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->
	
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<cfhttp url="#variables.CarrierServiceURL#/AttAccount?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>		
		<cfreturn processResults(cfhttp.fileContent) />		
	</cffunction>
	
	<cffunction name="areaCode" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<cfhttp url="#variables.CarrierServiceURL#/AttAreaCode?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>		
		<cfreturn processResults(cfhttp.fileContent) />		
	</cffunction>

	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->

	<!--- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--->
	<cffunction name="processResults" returnType="fw.model.CarrierApi.Att.AttCarrierResponse" access="private">
		<cfargument name="apiResultString" type="string" required="true" /> 
				
		<cfset var carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttCarrierResponse').init() />
		
		<cfif isJson(arguments.apiResultString)>
			<cfset carrierResponse.setResponse(deserializeJson(arguments.apiResultString,true)) />
			<cfset carrierResponse.setStatus(0) />
		<cfelse>
			<cfset carrierResponse.setStatus(404) />
		</cfif>
		
		<cfreturn carrierResponse />
	
	</cffunction>


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
			<cfif len(arglist)>
				<cfset arglist = arglist & "&" />
			</cfif>
			<cfset arglist = arglist & #theArg# & "=" & arguments[theArg] />
		</cfloop>		
		
		<cfreturn arglist />
		
	</cffunction>

</cfcomponent>