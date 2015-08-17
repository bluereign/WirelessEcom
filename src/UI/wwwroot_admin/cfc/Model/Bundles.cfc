<cfcomponent name="Bundles" output="false">

	<cffunction name="init" access="public" returntype="Bundles" output="false">

		<cfset this.dsn = application.dsn.wirelessadvocates />

		<cfreturn this />
	</cffunction>

	<cffunction name="getBundles" access="public" returntype="query" output="false">
		<cfargument name="bundleId" required="false" type="numeric" />

		<cfset var getBundlesReturn = queryNew('undefined') />
		<cfset var qry_getBundles = '' />

		<cftry>
			<cfquery name="qry_getBundles" datasource="#this.dsn#">
				SELECT	b.Id, b.[Name], b.bundle, b.createdBy,
						b.createdOn, b.active
				FROM	catalog.bundle AS b WITH (NOLOCK)
				WHERE		b.active	=	<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				<cfif structKeyExists(arguments, 'bundleId')>
					AND		b.Id		=	<cfqueryparam value="#arguments.bundleId#" cfsqltype="cf_sql_integer" />
				</cfif>
				ORDER BY	b.[Name]
			</cfquery>

			<cfset getBundlesReturn = qry_getBundles />

			<cfcatch type="any">
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfcatch>
		</cftry>

		<cfreturn getBundlesReturn />
	</cffunction>
</cfcomponent>