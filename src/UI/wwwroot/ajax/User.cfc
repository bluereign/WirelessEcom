<cfcomponent output="false" displayname="User" hint="User CFC Facade for AJAX integration purposes" extends="cfc.model.User">

	<cffunction name="init" access="public" returntype="User" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="isEmailInUse" access="remote" returntype="boolean" output="false">
		<cfargument name="username" required="true" type="string" />

		<cfreturn super.isEmailInUse(trim(arguments.username)) />
	</cffunction>

	<cffunction name="isEmailPasswordValid" access="remote" returntype="boolean" output="false">
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" />

		<cfreturn super.isEmailPasswordValid(trim(arguments.username), trim(arguments.password)) />
	</cffunction>

	<cffunction name="login" access="remote" returntype="void" output="false">
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" />

		<cfset super.login(trim(arguments.username), trim(arguments.password)) />
	</cffunction>

	<cffunction name="createUser" access="remote" returntype="query" output="false">
		<cfargument name="username" required="false" type="string" default="" />
		<cfargument name="password" required="false" type="string" default="" />

		<cfreturn super.createUser(trim(arguments.username), trim(arguments.password)) />
	</cffunction>
</cfcomponent>