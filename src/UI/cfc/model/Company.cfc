<cfcomponent displayname="Company">

	<cffunction name="init" access="public" output="false" returntype="Company">
		<cfreturn this />
	</cffunction>

	<cffunction name="hasLogo" access="public" output="false" returntype="boolean">
		<cfargument name="CompanyGuid" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfquery name="local.qCheckCompanyLogo" datasource="#application.dsn.wirelessAdvocates#">
			SELECT ImageGuid
			FROM catalog.Image
			WHERE ReferenceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CompanyGuid#">
		</cfquery>
		<cfif local.qCheckCompanyLogo.recordCount>
			<cfset local.return = true>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getCompany" output="false" access="public" returntype="query">
		<cfargument name="companyId" required="true" type="numeric" />

		<cfset var getCompanyReturn = '' />
		<cfset var qry_getCompany = '' />

		<cfquery name="qry_getCompany" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	c.companyName
			FROM	catalog.company AS c WITH (NOLOCK)
			WHERE	c.carrierId = <cfqueryparam value="#arguments.companyId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfset getCompanyReturn = qry_getCompany />

		<cfreturn getCompanyReturn />
	</cffunction>


	<cffunction name="getAllCarriers" output="false" access="public" returntype="query">
		<cfset var qCarriers = '' />

		<cfquery name="qCarriers" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				c.CompanyName
				, c.CarrierId
			FROM catalog.company AS c WITH (NOLOCK)
			WHERE c.IsCarrier = 1
			ORDER BY CompanyName
		</cfquery>

		<cfreturn qCarriers />
	</cffunction>

</cfcomponent>