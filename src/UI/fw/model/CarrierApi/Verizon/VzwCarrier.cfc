<cfcomponent displayname="VzwCarrier" hint="Interface to Vzw Carrier API" extends="fw.model.CarrierApi.BaseCarrier" output="false">

	<cfset variables.NameMap = {
		PhoneNumber			= 	"MobileNumber",
		SecurityId			=	"SSN",
		Passcode			=	"PasswordPin"
	}/>
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Verizon.VzwCarrierResponse">
		<cfhttp url="#variables.CarrierServiceURL#/VerizonAccount" method="POST">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
    		<cfhttpparam type="body" value="#serializeJSON(remapArgs(argumentCollection=arguments))#">
		</cfhttp>
		<cfreturn processResults(cfhttp) />	
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->

	<!--- 
		Look at the results of the call and set appropriate fields in the carrier response	
	--->
	<cffunction name="processResults" returnType="fw.model.CarrierApi.Verizon.VzwCarrierResponse" access="private">
		<cfargument type="struct" name="cfhttpResult" required="true" /> 
		<cfset var emptyObj = {} />
				
		<cfset var carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Verizon.VzwCarrierResponse').init() />
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

	<!---
		remap args keys into verizon specific names
	 --->
	<cffunction name="remapArgs" returnType="struct" access="public">
	
		<cfset var argsout = structNew() />
		<cfset var map = ""/>
		<cfset var theArg = "" />
		
		<cfloop collection="#arguments#" item="theArg">
			<cfset map = structFindKey(variables.NameMap,"#theArg#") />
			<cfif arraylen(map)>
				<cfset structInsert(argsout, map[1].value, arguments[theArg]) />
			<cfelse>
				<cfset structInsert(argsout, "#theArg#", arguments[theArg]) />
			</cfif>
		</cfloop>	
		
		<cfreturn argsout />
		
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