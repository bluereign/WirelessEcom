<cfcomponent name="Bundles" output="false">

	<cffunction name="init" returntype="Bundles" output="false">

		<cfset this.model = application.model.bundles />

		<cfreturn this />
	</cffunction>

	<cffunction name="getBundles" access="public" returntype="query" output="false">
		<cfargument name="bundleId" required="false" type="numeric" />

		<cfset var getBundlesReturn = this.model.getBundles(argumentCollection = arguments) />

		<cfreturn getBundlesReturn />
	</cffunction>
</cfcomponent>