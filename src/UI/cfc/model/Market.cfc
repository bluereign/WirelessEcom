<cfcomponent output="false" displayname="Market">

	<cffunction name="init" returntype="Market">
		<cfreturn this />
	</cffunction>

	<cffunction name="getByZipCode" returntype="query">
		<cfargument name="zipcode" type="numeric" required="true">
		<cfset var local = structNew()>

		<cfif not isDefined("request.model.market.getByZipCode.qMarketsByZipcode")> <!--- TRV: adding some "pseudo-caching" to ensure that we don't run this against the database more than once in a single request --->
			<cfquery name="local.qMarketsByZipCode" datasource="#application.dsn.wirelessAdvocates#">
				SELECT DISTINCT
					MarketGuid
				FROM
					catalog.ZipCodeMarket
				WHERE
					ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zipcode#">
			</cfquery>
			<cfset request.model.market.getByZipCode.qMarketsByZipcode = local.qMarketsByZipCode>
		<cfelse>
			<cfset local.qMarketsByZipCode = request.model.market.getByZipCode.qMarketsByZipcode>
		</cfif>
	
		<cfreturn local.qMarketsByZipCode>
	</cffunction>

</cfcomponent>