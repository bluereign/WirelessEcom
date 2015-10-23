<cfcomponent displayname="AttCarrier" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.BaseCarrier" output="false">
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------
		Carrier API Entry Points (alphabetical order)
	----------------------------------------------------------------------------------------------------->
	
	<!--- Perform an Account Lookup and retrieve account information for the customer --->
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAccountCarrierResponse">
		<cfset var local = structNew() />	
		<cfhttp url="#variables.CarrierServiceURL#/account/login" method="POST" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#serializeJSonAddReferenceNumber(arguments)#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAccountCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfreturn processResponse(local.carrierResponse) />	
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Based on Zip Code check to see the supported area codes for the carrier  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="areaCode" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAreaCodeCarrierResponse">
		<cfset var local = structNew() />	
		<cfhttp url="#variables.CarrierServiceURL#/areaCode?#argslist(argumentCollection=arguments)#" method="Get" result="local.cfhttp">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAreaCodeCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfreturn processResponse(local.carrierResponse) />	
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Request the Finance Agreement PDf  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="FinanceAgreement" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttFinanceAgreementCarrierResponse">
		<cfset var local = structNew() />
		<cfset local.body = serializeJSonAddReferenceNumber(arguments) />	
		<cfhttp url="#variables.CarrierServiceURL#/FinanceAgreement" method="Post" result="local.cfhttp">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#local.body#">
		</cfhttp>
		
		<!--- create the carrier response --->
		<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttFinanceAgreementCarrierResponse').init() />
		<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
		<cfreturn processResponse(local.carrierResponse) />	
		
	</cffunction>
	
	
	<!-------------------------------------------------------------------------------------------------------- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--------------------------------------------------------------------------------------------------------->
	
	<cffunction name="processResults" returnType="Any" access="private">
		<cfargument type="struct" name="cfhttpResult" required="true" /> 
		<cfargument type="any" name="carrierResponse" required="true" /> 
		<cfset var emptyObj = {} />
		
		<!--- create the carrier response --->
		<cfset carrierResponse.setHttpStatus(arguments.cfhttpResult.statusCode) />
		<cfif isdefined("arguments.cfhttpResult.responseHeader.status_code") and isNumeric(arguments.cfhttpResult.responseHeader.status_code) >
			<cfset carrierResponse.setHttpStatusCode(arguments.cfhttpResult.responseHeader.status_code) />
		</cfif>
		
		<!--- Copy the response or an empty object into the carrierResponse --->
		<cfif isJson(arguments.cfhttpResult.fileContent)>			
			<cfset carrierResponse.setResponse(deserializeResponse(arguments.cfhttpResult.fileContent)) />
				<!---<cfset carrierResponse.setResponse(deserializeJSON(arguments.cfhttpResult.fileContent,true)) />--->
		<cfelse>
			<cfset carrierResponse.setResponse(emptyObj) />
		</cfif>
		
		<cfif arguments.cfhttpResult.responseHeader.status_code is 200>			
			<cfset carrierResponse.setResult(true) />
			<cfset carrierResponse.setResultDetail("OK") />
		<cfelse>
			<cfset carrierResponse.setResult(false) />
			<cfset carrierResponse.setResultDetail("Processing Error") />
		</cfif>
		
		<cfreturn carrierResponse />
	
	</cffunction>

	<!---
		Get the Service URL
	 --->
	<cffunction name="getServiceURL" returnType="string" access="public">
		<cfreturn variables.CarrierServiceURL />
	</cffunction>

</cfcomponent>