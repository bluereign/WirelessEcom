<cfcomponent displayname="VZW Carrier Response" hint="Contains response from carrier info" output="false" extends="fw.model.CarrierApi.CarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Verizon.VzwCarrierResponse">
		
		<cfset super.init() />
		
		<cfreturn this />
		
	</cffunction>
	


	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "#missingMethodName#: method not found" />
	</cffunction>

</cfcomponent>