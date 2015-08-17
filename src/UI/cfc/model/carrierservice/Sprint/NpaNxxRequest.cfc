<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Sprint.NpaNxxRequest">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" default="0" required="false" />
		<cfset variables.instance.ZipCode = arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ZipCode />
	</cffunction>

	<cffunction name="setReferenceNumber" output="false" access="public" returntype="void">
		<cfargument name="ReferenceNumber" type="string" default="0" required="false" />
		<cfset variables.instance.ReferenceNumber = arguments.ReferenceNumber />
	</cffunction>
	<cffunction name="getReferenceNumber" output="false" access="public" returntype="string">
		<cfreturn variables.instance.ReferenceNumber />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>