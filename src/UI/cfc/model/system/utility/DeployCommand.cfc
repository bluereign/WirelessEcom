<cfcomponent name="DeployCommand" output="false">
	<cffunction name="init" access="public" returntype="any" hint="Constructor" output="false" >
		<cfargument name="controller" required="true" type="coldbox.system.web.Controller" hint="The coldbox controller">
		<cfset instance = structnew()>
		<cfset instance.controller = arguments.controller>
	</cffunction>
	
	<cffunction name="execute" access="public" returntype="void" hint="Execute Command" output="false" >
		<cftry>
			<cflog log="Application" type="information" text="Running deploy command to flush variables." /> 
			<cfset application.wirebox.clearSingletons() />
			<cfset getColdBoxOCM().expireAll() />
			<cfset applicationStop() />
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>