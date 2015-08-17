<cfcomponent hint="User Authentication" output="false">

	<cffunction name="init" access="public" hint="Initalizes the Component">

    	<cfreturn this>
    </cffunction>

	<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
		<cfset var local = structNew() />
		<cfset local.result = false />

		<cfparam name="session.userId" default="0" type="numeric" />

		<cfif structKeyExists(session, 'userId') and len(trim(session.userId)) and isNumeric(session.userId) and session.userId>
			<cfset local.result = true />
		</cfif>

		<cfreturn local.result />
	</cffunction>

</cfcomponent>