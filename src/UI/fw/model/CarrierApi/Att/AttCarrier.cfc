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
		<cfhttp url="#variables.CarrierServiceURL#/AttAccount?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>		
		<cfreturn processResults(cfhttp) />	
	</cffunction>
	
	<cffunction name="areaCode" output="false" access="public" returntype="fw.model.CarrierApi.Att.AttCarrierResponse">
		<cfhttp url="#variables.CarrierServiceURL#/AttAreaCode?#argslist(argumentCollection=arguments)#" method="GET"></cfhttp>		
		<cfreturn processResults(cfhttp) />		
	</cffunction>

	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->


	<!---
		Get the Service URL
	 --->
	<cffunction name="getServiceURL" returnType="string" access="public">
		<cfreturn variables.CarrierServiceURL />
	</cffunction>

</cfcomponent>