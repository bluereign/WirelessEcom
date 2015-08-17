<cfcomponent output="false" displayname="VFD">
	
	<cffunction name="init" access="public" returntype="cfc.model.VFD" output="false">
		<cfargument name="employeeNumber" type="string" default="" required="false" />
		<cfargument name="kioskNumber" type="string" default="" required="false" />
		<cfargument name="access" type="boolean" default="false" required="false" />
		<cfargument name="expires" type="string" default="false" required="false" />

		<cfset variables.instance = structNew() />
		<cfset setEmployeeNumber(arguments.employeeNumber) />
		<cfset setKioskNumber(arguments.kioskNumber) />
		<cfset setAccess(arguments.access) />
		<cfset setExpires(arguments.expires) />

		<cfreturn this />
	</cffunction>
	
	<cffunction name="loginVFD" access="public" returntype="void" output="false">
		<cfargument name="employeeNumber" type="string" required="true">
		<cfargument name="kioskNumber" type="string" required="true">
		<cfargument name="access" type="boolean" required="true">
		
		<cfset var local = structNew()>

		<cfset session.vfd = createObject('component','cfc.model.vfd').init()>
		<cfset setEmployeeNumber(arguments.employeeNumber) />
		<cfset setKioskNumber(arguments.kioskNumber) />
		<cfset setAccess(arguments.access) />

	</cffunction>
	
	<cffunction name="logoutVFD" access="public" returntype="void" output="false">
		<cfset structClear(session.VFD) />
	</cffunction>
	
    <!--- getters --->

    <cffunction name="getEmployeeNumber" returntype="string">
		<cfreturn variables.instance.employeeNumber>
	</cffunction>

    <cffunction name="getKioskNumber" returntype="string">
		<cfreturn variables.instance.kioskNumber>
	</cffunction>

    <cffunction name="getAccess" returntype="boolean">
		<cfreturn variables.instance.access>
	</cffunction>
	
	<cffunction name="getExpires" returntype="string">
		<cfreturn variables.instance.expires>
	</cffunction>

	<!--- setters --->

    <cffunction name="setEmployeeNumber" returntype="void">
		<cfargument name="employeeNumber" type="string" required="true">
		<cfset variables.instance.employeeNumber = arguments.employeeNumber>
	</cffunction>

    <cffunction name="setKioskNumber" returntype="void">
		<cfargument name="kioskNumber" type="string" required="true">
		<cfset variables.instance.kioskNumber = arguments.kioskNumber>
	</cffunction>

    <cffunction name="setAccess" returntype="void">
		<cfargument name="access" type="boolean" required="true">
		<cfset variables.instance.access = arguments.access>
	</cffunction>
	
	<cffunction name="setExpires" returntype="void">
		<cfargument name="expires" type="string" required="true">
		<cfset variables.instance.expires = arguments.expires>
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>