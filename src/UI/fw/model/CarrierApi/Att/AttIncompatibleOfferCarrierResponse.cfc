<cfcomponent displayname="ATT Incompatible Offer Carrier Response" hint="ATT Incompatible Offer Carrier Response" extends="fw.model.carrierapi.att.attcarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttIncompatibleOfferCarrierResponse">		
		<cfset super.init() />
		<cfreturn this />		
	</cffunction>	

	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "AttIncompatibleOfferCarrierResponse - #missingMethodName#: method not found" />
	</cffunction>	
	
</cfcomponent>