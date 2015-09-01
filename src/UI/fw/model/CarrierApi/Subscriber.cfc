<cfcomponent displayname="FullAPI Subscriber" hint="Generic Subscriber model" output="false">

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Subscriber">
		
		<cfset variables.instance = structNew() />	
		
		<cfreturn this />
	</cffunction>
	
	
	<!---
		Setters / Getters	
	 --->
	
	<cffunction name="setAccountStatus" returnType="void" access="public">
		<cfargument name="accountStatus" type="string" required="true">
		<cfset variables.instance.accountStatus = arguments.accountStatus />
	</cffunction>

	<cffunction name="getAccountStatus" returnType="string" access="public">
		<cfif isDefined("variables.instance.accountStatus")>
			<cfreturn variables.instance.accountStatus />
		<cfelse>
			<cfreturn "undefined" />
		</cfif>
	</cffunction>	
	
	<cffunction name="setAddress" returnType="void" access="public">
		<cfargument name="address" type="cfc.model.address" required="true" />
		<cfset variables.instance.address = arguments.address />
	</cffunction>
	
	<cffunction name="getAddress" returnType="cfc.model.address" access="public">
		<cfif isDefined("variables.instance.address") >
			<cfreturn variables.instance.address />
		<cfelse>
			<cfreturn CreateObject( "component", "cfc.model.Address" ).init(  ) />
		</cfif>
	</cffunction>
	
	
	<cffunction name="setEmail" returnType="void" access="public">
		<cfargument name="email" type="string" required="true" />
		<cfset variables.instance.email = arguments.email />
	</cffunction>
	
	<cffunction name="getEmail" returnType="string" access="public">
		<cfif isDefined("variables.instance.email") >
			<cfreturn variables.instance.email />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

	
	
	
	
</cfcomponent>