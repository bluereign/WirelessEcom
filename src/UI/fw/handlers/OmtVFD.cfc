<cfcomponent output="false" extends="BaseHandler">
	
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />

		
	
	<cffunction name="main" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset rc.bBootStrapIncluded = true>

		<cfset event.setView('VFD/omt/main') />
	</cffunction>
	
	
	
	<cffunction name="order" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset rc.bBootStrapIncluded = true>

		<cfset event.setView('VFD/omt/order') />
	</cffunction>
	
</cfcomponent>