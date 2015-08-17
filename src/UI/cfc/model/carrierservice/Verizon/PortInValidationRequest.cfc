<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	

	<cffunction name="setServiceAreaZip" output="false" access="public" returntype="void">
		<cfargument name="ServiceAreaZip" type="string" default="0" required="false" />
		<cfset this.RequestBody.ServiceAreaZip = ' ' & arguments.ServiceAreaZip /> 
	</cffunction>
	<cffunction name="getServiceAreaZip" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ServiceAreaZip />
	</cffunction>
	
	<cffunction name="setMdns" output="false" access="public" returntype="void">
		<cfargument name="Mdns" type="array" default="0" required="false" />
		<cfset this.RequestBody.Mdns = arguments.Mdns />
	</cffunction>
	<cffunction name="getMdns" output="false" access="public" returntype="array">
		<cfreturn this.RequestBody.Mdns />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>