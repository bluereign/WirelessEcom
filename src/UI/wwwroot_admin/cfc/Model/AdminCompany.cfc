<cfcomponent output="false" displayname="AdminCompany">

	<cffunction name="init" access="public" returntype="AdminCompany" output="false">

		<cfreturn this />
	</cffunction>

	<cffunction name="getCompany" access="public" returntype="query" output="false">
		<cfargument name="comanyId" type="string" required="true" />

		<cfset var local = {
			comanyId = trim(arguments.comanyId)
		} />

		<cfquery name="local.getCompany" datasource="#application.dsn.wirelessadvocates#">
			SELECT	c.CompanyGuid, c.CompanyName, c.IsCarrier, c.CarrierId
			FROM	catalog.Company AS c WITH (NOLOCK)
			WHERE	c.CompanyGuid	=	<cfqueryparam value="#local.comanyId#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn local.getCompany />
	</cffunction>

	<cffunction name="getCompanies" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrierId" required="false" type="numeric" />

		<cfset var local = {
			filter = arguments.filter
		} />

		<cfif structKeyExists(arguments, 'carrierId') and arguments.carrierId eq 0>
			<cfset local.filter.isCarrier = true />
		</cfif>

		<cfquery name="local.getCompanies" datasource="#application.dsn.wirelessadvocates#">
			SELECT		c.CompanyGuid, c.CompanyName, c.IsCarrier, c.CarrierId
			FROM		catalog.Company AS c WITH (NOLOCK)
			WHERE		1	=	1
			<cfif isStruct(local.filter) and structKeyExists(local.filter, 'isCarrier')>
				<cfif local.filter.isCarrier>
					AND	c.IsCarrier	=	<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
				<cfelse>
					AND	c.IsCarrier	=	<cfqueryparam value="0" cfsqltype="cf_sql_bit" />
				</cfif>
			</cfif>
			<cfif structKeyExists(arguments, 'carrierId') and arguments.carrierId gt 0>
				AND		c.carrierId		=	<cfqueryparam value="#arguments.carrierId#" cfsqltype="cf_sql_integer" />
			</cfif>
			ORDER BY	c.companyName
		</cfquery>

		<cfreturn local.getCompanies />
	</cffunction>
</cfcomponent>