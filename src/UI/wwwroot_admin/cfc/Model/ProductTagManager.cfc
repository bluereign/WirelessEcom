<cfcomponent displayname="ProductTagManager">
	<cffunction name="init" returntype="ProductTagManager">
		<cfset var local = structNew()>
		<cfset variables.instance = structNew()>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProductTags" returntype="query">
		<cfargument name="productGuid" type="string">
		
		<cfset var local = {
			productGuid = arguments.productGuid		
		} />
		
		<cftry>
			<cfquery name="local.getProductTags" datasource="#application.dsn.wirelessadvocates#">
				SELECT ProductGuid,
					   Tag
				FROM catalog.ProductTag
				WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getProductTags />
	</cffunction>

	<cffunction name="saveProductTags" returntype="string">
		<cfargument name="productGuid" type="string">
		<cfargument name="tagList" type="string">
		
		<cfset var local = {
			productGuid = arguments.productGuid,
			tagList = arguments.tagList
		} />
		
		<!--- delete all productTags from db --->
		<cftry>
			<cfquery name="local.purgeProductTags" datasource="#application.dsn.wirelessadvocates#">
				DELETE FROM catalog.ProductTag
				WHERE ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<!--- add the tags from the passed in tagList --->
		<cfloop list="#local.tagList#" index="local.tag">
			<cftry>
				<cfquery name="local.purgeProductTags" datasource="#application.dsn.wirelessadvocates#">
					INSERT INTO catalog.ProductTag (
						ProductGuid,
						Tag
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.tag#" />
					)
				</cfquery>
				<cfcatch type="any">
					<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
				</cfcatch>
			</cftry>
		</cfloop>
				
		<cfreturn "success" />
	</cffunction>
</cfcomponent>