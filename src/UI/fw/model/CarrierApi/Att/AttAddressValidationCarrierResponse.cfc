<cfcomponent displayname="ATT Address Validation Response" hint="ATT Address Validation Carrier Response" extends="fw.model.carrierapi.att.attcarrierResponse">

	<cfset variables.instance = structNew() />
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttAddressValidationCarrierResponse">		
		<cfset super.init() />
		<cfreturn this />		
	</cffunction>	

</cfcomponent>