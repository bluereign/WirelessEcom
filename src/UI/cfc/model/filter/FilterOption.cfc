<cfcomponent output="false" displayname="FilterOption">

	<cffunction name="init" returntype="FilterOption">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getFilterGroupById" returntype="any">
		<cfargument name="filterGroupId" type="numeric" />
		
		<cfset var local = {} />
		
		<cfquery name="local.qFilterGroup" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				filterOptionId,
				filterGroupId,
				label,
				tag,
				dynamicTag,
				Ordinal,
				active
			FROM
				catalog.filterOption
			WHERE
				filterGroupId = <cfqueryparam value="#arguments.filterGroupId#" cfsqltype="cf_sql_integer" />
				<!--- AND	active = 1 --->
		</cfquery>
		
		<cfreturn local.qFilterGroup />
	</cffunction>
	
	<cffunction name="getFilterOptionById" returntype="any">
		<cfargument name="filterOptionId" type="numeric" />
		
		<cfset var local = {} />
		
		<cfquery name="local.qFilterOption" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				filterOptionId,
				filterGroupId,
				label,
				tag,
				dynamicTag,
				Ordinal,
				active
			FROM
				catalog.filterOption
			WHERE
				filterOptionId = <cfqueryparam value="#arguments.filterOptionId#" cfsqltype="cf_sql_integer" />
				AND	active = 1
		</cfquery>
		
		<cfreturn local.qFilterOption />
	</cffunction>
	
	<cffunction name="runDynamicTag" returntype="any">
		<cfargument name="dynamicTag" type="string" />
		
		<cfset var local = {} />
	
		<cfquery name="local.qDynamicTag" datasource="#application.dsn.wirelessAdvocates#">
			#PreserveSingleQuotes(arguments.dynamicTag)#
		</cfquery>
		
		<cfreturn local.qDynamicTag />
	</cffunction>

</cfcomponent>