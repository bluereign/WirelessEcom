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
	
	<!------------------------------------------------------------------------------------------------------- 
		Store the Finance Agreement PDf  in the database
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="SaveFinanceAgreement" output="false" access="public" returntype="string">
		<cfset var local = structNew() />
		
		<cfif structKeyExists(arguments,"orderid") is false or isNumeric(arguments.orderid) is false>
			<cfreturn "Argument 'orderid' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"InstallmentPlanId") is false or isNumeric(arguments.installmentPlanId) is false>
			<cfreturn "Argument 'installmentPlanId' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"subscriberNumber") is false or isNumeric(arguments.subscriberNumber) is false>
			<cfreturn "Argument 'subscriberNumber' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"accountNumber") is false or isNumeric(arguments.accountNumber) is false>
			<cfreturn "Argument 'accountNumber' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"nameOnAccount") is false>
			<cfreturn "Argument 'nameOnAccount' is missing" />
		</cfif>
		<cfif structKeyExists(arguments,"acceptanceDate") is false or isDate(arguments.acceptanceDate) is false>
			<cfreturn "Argument 'acceptanceDate' is missing or non-date" />
		</cfif>
		<cfif structKeyExists(arguments,"Channel") is false or isNumeric(arguments.Channel) is false>
			<cfreturn "Argument 'channel' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"agreementTypeId") is false or isNumeric(arguments.agreementTypeId) is false>
			<cfreturn "Argument 'agreementTypeId' is missing or non-numeric" />
		</cfif>
		<cfif structKeyExists(arguments,"agreementEntry") is false>
			<cfreturn "Argument 'agreementEntry' is missing" />
		</cfif>
		
		<cfstoredproc datasource="wirelessadvocates" procedure="service.FinanceAgreementSave" result="local.result">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.orderid#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="109" > 
			<cfprocparam cfsqltype="CF_SQL_BIGINT" value="#arguments.installmentPlanId#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.subscriberNumber#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accountNumber#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.nameOnAccount#" > 
			<cfprocparam cfsqltype="CF_SQL_DATE" value="#arguments.acceptanceDate#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channel#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.agreementTypeId#" > 
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.agreementEntry#" > 
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="1" > <!--- Processing Status, Always 1 --->
		</cfstoredproc>
		
		<cfreturn "success" />
	</cffunction>
	
	<!------------------------------------------------------------------------------------------------------- 
		Request the Finance Agreement PDf  
	-------------------------------------------------------------------------------------------------------->
	<cffunction name="validateAddress" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttAddressValidationCarrierResponse">
		<cfset var local = structNew() />

		<!--- convert WA address object to a address request object --->
		<cfif structKeyexists(arguments,"address") and getMetaData(arguments.address).fullname is 'cfc.model.address'>
			<cfset local.validateAddressRequest = structNew() />
			<cfset local.validateAddressRequest.Address = structNew() />
			<cfset local.validateAddressRequest.Address.addressLine1 = arguments.address.getAddressLine1() />
			<cfset local.validateAddressRequest.Address.addressLine2 = arguments.address.getAddressLine2() />
			<cfset local.validateAddressRequest.Address.city = arguments.address.getCity() />
			<cfset local.validateAddressRequest.Address.state = arguments.address.getState() />
			<cfset local.validateAddressRequest.Address.zip = structNew() />
			<cfset local.validateAddressRequest.Address.zip.zip = arguments.address.getZipcode() />
			<cfset local.validateAddressRequest.Address.zip.zipExtension = arguments.address.getZipCodeExtension() />
			<cfset local.validateAddressRequest.Address.country = arguments.address.getCountry() />			
			<cfset local.validateAddressRequest.channel = arguments.channel />
			
			<cfset local.body = serializeJSonAddReferenceNumber(local.validateAddressRequest) />	
			<cfhttp url="#variables.CarrierServiceURL#/address" method="Post" result="local.cfhttp">
				<cfhttpparam type="header" name="Content-Type" value="application/json" />
	    		<cfhttpparam type="body" value="#local.body#">
			</cfhttp>
			
			<!--- create the carrier response --->
			<cfset local.carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttAddressValidationCarrierResponse').init() />
			<cfset local.carrierResponse = processResults(local.cfhttp,local.carrierResponse) />
			<cfreturn processResponse(local.carrierResponse) />	
		</cfif>		
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