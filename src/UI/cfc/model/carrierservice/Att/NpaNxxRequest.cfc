<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" default="0" required="false" />
		<cfset this.RequestBody.ZipCode = ' ' & arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn this.ZipCode />
	</cffunction>

	<cffunction name="setMethod" output="false" access="public" returntype="void">
		<cfargument name="Method" type="string" default="0" required="false" />
		<cfset this.RequestBody.Method = ' ' & arguments.Method />
	</cffunction>
	<cffunction name="getMethod" output="false" access="public" returntype="string">
		<cfreturn this.Method />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>