<cfcomponent displayname="ATT Area Code Carrier Response" hint="ATT Area Code Carrier Response" extends="fw.model.carrierapi.att.attcarrierResponse">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.att.AttAreaCodeCarrierResponse">		
		<cfset super.init() />
		<cfset variables.instance.subscribers = arraynew(1) />
		<cfreturn this />		
	</cffunction>	
	
	<cffunction name="IsValidZipCode" returntype="boolean"  >
		<cfset local = structNew() />
		<cfset local.resp = getResponse() />
		<cfif isdefined("local.resp.areacodes") and arraylen(local.resp.areacodes)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="getAreaCodes" returntype="string"  >
		<cfset local = structNew() />
		<cfset local.resp = getResponse() />
		<cfset local.areacodes = ""/>
		<cfif isdefined("local.resp.areacodes") and arraylen(local.resp.areacodes)>
			<cfloop array="#local.resp.areacodes#" index="ac">
				<cfset local.areacodes = listappend(local.areacodes,ac.areacode) />
			</cfloop>
			<cfreturn local.areacodes />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>
	
	
	<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
	    <cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
    	<cfargument name="MissingMethodArguments" type="struct" required="true" hint="The arguments that were passed to the missing method. This might be a named argument set or a numerically indexed set." />		
	    <cfreturn "AttAreaCodeCarrierResponse - #missingMethodName#: method not found" />
	</cffunction>	
	
</cfcomponent>