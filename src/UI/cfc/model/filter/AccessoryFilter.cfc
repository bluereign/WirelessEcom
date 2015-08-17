<cfcomponent output="false" displayname="AccessoryFilter">

	<cffunction name="init" returntype="AccessoryFilter">
		<cfreturn this />
	</cffunction>

	<cffunction name="getFilterGroupData" returntype="any">
		<cfargument name="groupId" type="numeric" />
		
		<cfset var local = {} />
		
		<!--- this variable controls whether filter with a "0" product count will be included or ignored --->
		<cfset local.bSuppressZeroCountFilters = true>

		<cfset local.producttype = "accessory">
		<cfset local.productview = "catalog.dn_Accessories">

		<!--- <cfquery name="local.qFilterGroups" datasource="#application.dsn.wirelessAdvocates#">
			SELECT *
			FROM catalog.filtergroup
			WHERE producttype = '#local.producttype#'
				AND active = 1
				AND filterGroupId = 12	
			ORDER BY ordinal
		</cfquery> --->

		<cfset local.aFilterData = [] />

		<cfset local.s = {} />
		<cfset local.s.filteroptions = [] />
		<cfset local.s.productCount = 0 />
		<cfset arrayAppend(local.aFilterData,local.s) />

		<cfquery name="local.qFilterOptions" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				FilterOptionId
			,	FilterGroupId
			,	Label
			,	Tag
			,	DynamicTag
			,	Ordinal
			,	Active
			FROM catalog.filteroption
			WHERE filtergroupid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#" />
				AND active = 1
			ORDER BY ordinal
		</cfquery>

		<cfreturn local.qFilterOptions />
	</cffunction>

	<cffunction name="getFilterData" returntype="any">
		<cfset var local = structNew()>

		<!--- this variable controls whether filter with a "0" product count will be included or ignored --->
		<cfset local.bSuppressZeroCountFilters = true>

		<cfset local.objCache = createObject('component','cfc.model.Cache').init()>
		<cfset local.cacheKey = "accessoryFilter,filterData">

		<cfset local.stcCache = local.objCache.get(listToArray(local.cacheKey))>

		<!--- TRV: disabling caching support for now
		<cfif local.stcCache.isValid>
			<cfset local.filterData = local.stcCache.cacheData>
		<cfelse>
--->
			<cfset local.producttype = "accessory">
			<cfset local.productview = "catalog.dn_Accessories">

			<cfquery name="local.qFilterGroups" datasource="#application.dsn.wirelessAdvocates#">
				select *
				from catalog.filtergroup
				where producttype = '#local.producttype#'
				and active = 1
				order by ordinal
			</cfquery>

			<cfset local.aFilterData = arrayNew(1)>

			<cfloop query="local.qFilterGroups">
				<cfset local.s = structNew()>
				<cfset local.s = application.model.Util.queryRowToStruct(local.qFilterGroups,local.qFilterGroups.currentRow)>
				<cfset local.s.filteroptions = arrayNew(1)>
				<cfset local.s.productCount = 0>
				<cfset arrayAppend(local.aFilterData,local.s)>

				<cfquery name="local.qFilterOptions" datasource="#application.dsn.wirelessAdvocates#">
					select
						FilterOptionId
					,	FilterGroupId
					,	Label
					,	Tag
					,	DynamicTag
					,	Ordinal
					,	Active
					from catalog.filteroption
					where filtergroupid = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qFilterGroups.filtergroupid[local.qFilterGroups.currentrow]#">
					and active = 1
					order by ordinal
				</cfquery>

				<cfloop query="local.qFilterOptions">
					<cfset local.s = structNew()>
					<cfset local.s = application.model.Util.queryRowToStruct(local.qFilterOptions,local.qFilterOptions.currentRow)>
					<cfset local.s.count = 0>
					<!--- attempt to run the dynamic sql for the filter option to establish a product count --->
					<cftry>
						<!--Set prodcount to 1 for now--->
						<cfset local.qFilterOptionProducts.prodcount = 1 />
						<cfset local.bValid = true>
						<!--- if the query failed, it's likely a bad dynamic tag --->
						<cfcatch type="any">
							<cfset local.bValid = false>
						</cfcatch>
					</cftry>
					<!--- only append the filter option data if the filter was deemed "valid" --->
					<cfif local.bValid>
						<!--- add/suppress the filter according to the product count and zero filter setting --->
						<cfif not local.bSuppressZeroCountFilters or local.qFilterOptionProducts.prodCount>
							<cfset local.s.count = local.qFilterOptionProducts.prodCount>
							<cfset local.aFilterData[local.qFilterGroups.currentRow].productCount = local.aFilterData[local.qFilterGroups.currentRow].productCount + local.s.count>
							<cfset arrayAppend(local.aFilterData[local.qFilterGroups.currentRow].filteroptions,local.s)>
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>

		<cfset local.filterData = local.aFilterData>

		<cfreturn local.filterData>
	</cffunction>

	<cffunction name="getUserSelectedFilterValuesByFieldName" returntype="string">
		<cfargument name="fieldName" type="variableName" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfif structKeyExists(session.accessoryFilterSelections,arguments.fieldName)>
			<cfset local.return = session.accessoryFilterSelections[arguments.fieldName]>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="saveFilterSelections" returntype="void">
		<cfargument name="formFields" type="struct" required="true">
		<cfset var local = structNew()>
		<!--- first, reset the user's current filter selections (since there may be checkboxes that were unchecked and, therefore, not defined) --->
		<cfset local.filterSelections = structNew()>
		<!--- loop through the supplied form fields --->
		<cfloop collection="#arguments.formFields#" item="local.x">
			<!--- if the form field appears to be filter related --->
			<cfif listFirst(local.x,".") eq "filter" or listLast(local.x,".") eq "sort">
				<!--- place the value of this form field into the user's filter selections --->
				<cfset local.filterSelections[listLast(local.x,".")] = request.p[local.x]>
			</cfif>
		</cfloop>
		<!--- TRV: adding code to preserve the compareIDs --->
		<cfif not structKeyExists(arguments.formFields,"compareIDs") and not structKeyExists(arguments.formFields,"filter.compareIDs") and structKeyExists(session.accessoryFilterSelections,"compareIDs")>
			<cfset local.filterSelections.compareIDs = session.accessoryFilterSelections.compareIDs>
		</cfif>
		<!--- TRV: adding code to preserve the sort --->
		<cfif not structKeyExists(arguments.formFields,"sort") and not structKeyExists(arguments.formFields,"filter.sort") and structKeyExists(evaluate("session.accessoryFilterSelections"),"sort")>
			<cfset local.filterSelections.sort = session.accessoryFilterSelections.sort>
		</cfif>
		<cfset session.accessoryFilterSelections = duplicate(local.filterSelections)>
		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="getAccessoryCategories" returntype="query">
		<cfset var local = structNew()>

		<cfquery name="local.qAccessoryCategoryOptions" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				FilterGroupId
			,	FilterOptionId
			,	Label
			FROM
				catalog.FilterOption
			WHERE
				FilterGroupId = 11
			AND	Active = 1
			ORDER BY
				Ordinal
		</cfquery>

		<cfreturn local.qAccessoryCategoryOptions>
	</cffunction>

	<cffunction name="getFilterTags" access="public" output="false" returntype="array">
		<cfset var local = structNew()>
		<cfset local.a = arrayNew(1)>

		<cfset local.a[1] = structNew()>
		<cfset local.a[1].label = "Cases">
		<cfset local.a[1].tag = "case">

		<cfset local.a[2] = structNew()>
		<cfset local.a[2].label = "Chargers">
		<cfset local.a[2].tag = "charger">

		<cfset local.a[3] = structNew()>
		<cfset local.a[3].label = "Headsets">
		<cfset local.a[3].tag = "headset">

		<cfset local.a[4] = structNew()>
		<cfset local.a[4].label = "Screen Protectors">
		<cfset local.a[4].tag = "screenprotectors">

		<cfreturn local.a>
	</cffunction>

	<cffunction name="setCompareIds" access="remote" output="false" returntype="void">
		<cfargument name="productIds" type="string" required="true">
		<cfargument name="productClass" type="string" default="accessory">
		<cfset var local = arguments>

		<cfparam name="session.#local.productClass#FilterSelections.compareIds" default="">

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.productIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#local.productClass#FilterSelections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
	</cffunction>

	<cffunction name="addCompareId" access="remote" output="false" returntype="void">
		<cfargument name="productId" type="string" required="true">
		<cfargument name="productClass" type="string" default="accessory">
		<cfset var local = arguments>

		<cfparam name="session.#local.productClass#FilterSelections.compareIds" default="">
		<cfset local.compareIds = evaluate("session.#local.productClass#FilterSelections.compareIds")>

		<cfif not listFindNoCase(local.compareIds,local.productId)>
			<cfset local.compareIds = listAppend(local.compareIds,local.productId)>
		</cfif>

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.compareIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#local.productClass#FilterSelections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
	</cffunction>

	<cffunction name="removeCompareId" access="remote" output="false" returntype="void">
		<cfargument name="productId" type="string" required="false" default="">
		<cfargument name="productClass" type="string" default="accessory">
		<cfset var local = arguments>

		<cfparam name="session.#local.productClass#FilterSelections.compareIds" default="">
		<cfset local.compareIds = evaluate("session.#local.productClass#FilterSelections.compareIds")>

		<cfif len(trim(local.productId))>
			<cfset local.compareIds = application.model.Util.listDelete(local.productId,local.compareIds) />
		</cfif>

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.compareIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#local.productClass#FilterSelections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
	</cffunction>

	<cffunction name="setSort" access="remote" output="false" returntype="void">
		<cfargument name="sort" type="string" required="true">
		<cfset var local = arguments>
		<cfparam name="session.accessoryFilterSelections.sort" default="category">
		<cfset "session.accessoryFilterSelections.sort" = local.sort>

		<!--- throw a flag to indicate that we've changed the user's session data --->
	</cffunction>

	<cffunction name="getSort" access="public" output="false" returntype="string">
		<cfparam name="session.accessoryFilterSelections.sort" default="category">
		<cfreturn session.accessoryFilterSelections.sort>
	</cffunction>

</cfcomponent>