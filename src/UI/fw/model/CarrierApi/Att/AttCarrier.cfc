<cfcomponent displayname="AttCarrier" hint="Interface to ATT Carrier API" extends="fw.model.BaseService" output="false">
	
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrier">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="account" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<cfset var carrierResponse =  CreateObject('component', 'fw.model.CarrierApi.Att.AttCarrierResponse').init() />
		
		<cfset var args = argslist(argumentCollection=arguments) />
		<cfhttp url="#variables.CarrierServiceURL#/AttAccount?#argslist(argumentCollection=arguments)#" method="GET">
		</cfhttp>
		
		<cfif isJson(cfhttp.filecontent)>
			<cfset carrierResponse.setResponse(deserializeJson(cfhttp.filecontent,true)) />
			<cfset carrierResponse.setStatus(0) />
		<cfelse>
			<cfset carrierResponse.setStatus(404) />
		</cfif>
		
		<cfreturn carrierResponse />
		
	</cffunction>
	
	
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