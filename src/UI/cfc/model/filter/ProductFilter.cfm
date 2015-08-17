	<cffunction name="getFilterData" returntype="any" output="false" access="public">
		<cfset var local = {} />

		<!--- this variable controls whether filter with a "0" product count will be included or ignored --->
		<cfset local.bSuppressZeroCountFilters = true />

		<cfset local.objCache = createObject('component','cfc.model.Cache').init() />
		<cfset local.cacheKey = "#variables.filterType#,filterData" />

		<cfset local.stcCache = local.objCache.get(listToArray(local.cacheKey)) />

		<!--- TRV: disabling caching support for now
		<cfif local.stcCache.isValid>
			<cfset local.filterData = local.stcCache.cacheData>
		<cfelse>
--->
			<cfset local.producttype = variables.productClass />
			<cfset local.productview = "catalog.#variables.indexedViewName#" />
			<cfset local.producttag = variables.productTag />
			
			<cfif listFind( getUserSelectedFilterValuesByFieldName(fieldName="filterOptions"), "32" )>
				<cfset local.priceGroupCode = "ECN" />
			<cfelseif listFind( getUserSelectedFilterValuesByFieldName(fieldName="planType"), "33" )>
				<cfset local.priceGroupCode = "ECU" />
			<cfelseif listFind( getUserSelectedFilterValuesByFieldName(fieldName="planType"), "34" )>
				<cfset local.priceGroupCode = "ECA" />
			<cfelse>
				<cfset local.priceGroupCode = "ECN" />
			</cfif>

			<cfquery name="local.qFilterGroups" datasource="#application.dsn.wirelessAdvocates#">
				SELECT FilterGroupId
				, ProductType
				, Label
				, FieldName
				, AllowSelectMultiple
				FROM catalog.filtergroup
				WHERE producttype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.producttype#" />
				AND active = 1
				ORDER BY ordinal
			</cfquery>

			<cfset local.aFilterData = arrayNew(1) />

			<cfloop query="local.qFilterGroups">
				<cfset local.s = structNew() />
				<cfset local.s = application.model.Util.queryRowToStruct(local.qFilterGroups,local.qFilterGroups.currentRow) />
				<cfset local.s.filteroptions = arrayNew(1) />
				<cfset local.s.productCount = 0 />
				<cfset arrayAppend(local.aFilterData,local.s) />

				<cfquery name="local.qFilterOptions" datasource="#application.dsn.wirelessAdvocates#">
					SELECT
						FilterOptionId
					,	FilterGroupId
					,	Label
					,	Tag
					,	replace(dynamicTag,'$pricegroupcode$','#local.priceGroupCode#') as DynamicTag
					,	Ordinal
					,	Active
					FROM catalog.filteroption AS f WITH (NOLOCK)
					WHERE filtergroupid = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.qFilterGroups.filtergroupid[local.qFilterGroups.currentrow]#">
					AND active = 1
					ORDER BY ordinal
				</cfquery>

				<cfloop query="local.qFilterOptions">
					<cfset local.s = structNew() />
					<cfset local.s = application.model.Util.queryRowToStruct(local.qFilterOptions,local.qFilterOptions.currentRow) />
					<cfset local.s.count = 0 />
					<!--- attempt to run the dynamic sql for the filter option to establish a product count --->
					<cftry>
						<cfset local.qFilterOptionProducts.prodcount = 1 >
						<cfset local.bValid = true />
						<!--- if the query failed, it's likely a bad dynamic tag --->
						<cfcatch type="any">
							<cfset local.bValid = false />
						</cfcatch>
					</cftry>
					<!--- only append the filter option data if the filter was deemed "valid" --->
					<cfif local.bValid>
						<!--- add/suppress the filter according to the product count and zero filter setting --->
						<cfif not local.bSuppressZeroCountFilters or local.qFilterOptionProducts.prodCount>
							<cfset local.s.count = local.qFilterOptionProducts.prodCount />
							<cfset local.aFilterData[local.qFilterGroups.currentRow].productCount = local.aFilterData[local.qFilterGroups.currentRow].productCount + local.s.count />
							<cfset arrayAppend(local.aFilterData[local.qFilterGroups.currentRow].filteroptions,local.s) />
						</cfif>
					</cfif>
				</cfloop>
			</cfloop>

<!--- TRV: disabling caching support for now
			<cfset local.stcCache = local.objCache.save(listToArray(local.cacheKey),local.aFilterData,now()+createTimeSpan(0,0,20,0))>

			<cfset local.filterData = local.stcCache.cacheData>
		</cfif>
--->

		<cfset local.filterData = local.aFilterData />

		<cfreturn local.filterData />
	</cffunction>

	<cffunction name="getUserSelectedFilterValuesByFieldName" returntype="string" output="false">
		<cfargument name="fieldName" type="any" required="true" />
		<cfset var local = structNew() />
		<cfset local.return = "" />
		<cfset local.filterSelections = evaluate("session.#variables.filterType#Selections") />
		<cfif structKeyExists(local.filterSelections,arguments.fieldName)>
			<cfset local.return = local.filterSelections[arguments.fieldName]>
		</cfif>
		<cfreturn local.return />
	</cffunction>

	<cffunction name="saveFilterSelections" returntype="void">
		<cfargument name="formFields" type="struct" required="true">
		<cfset var local = structNew()>
		<!--- first, reset the user's current filter selections (since there may be checkboxes that were unchecked and, therefore, not defined) --->
		<cfset local.filterSelections = structNew()>
		<!--- loop through the supplied form fields --->
		<cfloop collection="#arguments.formFields#" item="local.x">
			<!--- if the form field appears to be filter related --->
			<cfif local.x eq "filter.filterOptions" or listLast(local.x,".") eq "sort">
				<!--- place the value of this form field into the user's filter selections --->
				<cfset local.filterSelections[listLast(local.x,".")] = request.p[local.x]>
			</cfif>
		</cfloop>
		<!--- TRV: adding code to preserve the compareIDs --->
		<cfif not structKeyExists(arguments.formFields,"compareIDs") and not structKeyExists(arguments.formFields,"filter.compareIDs") and structKeyExists(evaluate("session.#variables.filterType#Selections"),"compareIDs")>
			<cfset local.filterSelections.compareIDs = evaluate("session.#variables.filterType#Selections.compareIDs")>
		</cfif>
		<!--- TRV: adding code to preserve the sort --->
		<cfif not structKeyExists(arguments.formFields,"sort") and not structKeyExists(arguments.formFields,"filter.sort") and structKeyExists(evaluate("session.#variables.filterType#Selections"),"sort")>
			<cfset local.filterSelections.sort = evaluate("session.#variables.filterType#Selections.sort")>
		</cfif>
		<!--- adding code to preserve the activation price --->
		<cfif not structKeyExists(arguments.formFields,"ActivationPrice") and not structKeyExists(arguments.formFields,"filter.ActivationPrice") and structKeyExists(evaluate("session.#variables.filterType#Selections"),"ActivationPrice")>
			<cfset local.filterSelections.ActivationPrice = evaluate("session.#variables.filterType#Selections.ActivationPrice")>
		</cfif>		
		<cfset "session.#variables.filterType#Selections" = duplicate(local.filterSelections)>
		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<!--- TRV: this method needs to be kept since it is used to determine which carriers should be listing in the top nav based on which ones are deemed to have datacard/netbook products available --->
	<cffunction name="getProductCarriers" returntype="query">
		<cfset var local = structNew()>

		<cfquery name="local.qGetFilter_ProductCarriers" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'#variables.productClass#' as filterType
			,	'Carrier' as filterGroupLabel
			,	1 as filterGroupOrder
			,	'carrierID' as filterFieldName
			,	'checkbox' as filterControlType
			,	p.carrierName as filterLabel
			,	CONVERT(varchar(50), p.carrierID) as filterValue
			,	ROW_NUMBER() over (order by p.carrierName) as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				1=1
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
			group by
				p.carrierID
			,	p.carrierName
			order by p.carrierName asc
		</cfquery>

		<cfreturn local.qGetFilter_ProductCarriers>
	</cffunction>

	<!--- TRV: this method needs to be kept since it is used to update the price filter counts based on a change in lob/activation type --->
	<cffunction name="getProductPricing" returntype="query">
		<cfargument name="planType" type="string" default="">
		<cfset var local = structNew()>
		<cfset local.filterSelections = evaluate(variables.filterSelections)>
		<cfset local.planType = arguments.planType>
		<cfif not len(trim(local.planType))>
			<cfif listFind(application.model[variables.filterType].getUserSelectedFilterValuesByFieldName(fieldName="filterOptions"),"32")>
				<cfset local.planType = "new">
			<cfelseif listFind(application.model[variables.filterType].getUserSelectedFilterValuesByFieldName(fieldName="planType"),"33")>
				<cfset local.planType = "upgrade">
			<cfelseif listFind(application.model[variables.filterType].getUserSelectedFilterValuesByFieldName(fieldName="planType"),"34")>
				<cfset local.planType = "addaline">
			<cfelse>
				<cfset local.planType = "new">
			</cfif>
		</cfif>
		<cfif local.planType eq "new">
			<cfset local.priceGroupCode = "ECN">
		<cfelseif local.planType eq "upgrade">
			<cfset local.priceGroupCode = "ECU">
		<cfelseif local.planType eq "addaline">
			<cfset local.priceGroupCode = "ECA">
		</cfif>

		<cfquery name="local.qGetPricingFilterOptions" datasource="#application.dsn.wirelessAdvocates#">
			select
				FilterOptionId
			,	FilterGroupId
			,	Label
			,	Tag
			,	replace(dynamicTag,'$pricegroupcode$','#local.priceGroupCode#') as DynamicTag
			,	Ordinal
			,	Active
			from catalog.filteroption
			where filtergroupid = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
			and active = 1
			order by ordinal
		</cfquery>

		<cfquery name="local.qGetFilter_ProductPricing" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<cfloop query="local.qGetPricingFilterOptions">
				select
					#local.qGetPricingFilterOptions.filterOptionId[local.qGetPricingFilterOptions.currentRow]# as filterOrder
				,	count(*) as filterItemCount
				from catalog.#variables.indexedViewName# p
				where exists (
					select 1
					from (
						<cfset local.sql = local.qGetPricingFilterOptions.dynamictag[local.qGetPricingFilterOptions.currentrow]>
						#preserveSingleQuotes(local.sql)#
					) as prod
					where prod.ProductGuid = p.ProductGuid
				)
				and exists (
					select 1
					from
						catalog.ProductTag pt
					where
						pt.tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
					AND	pt.productguid = p.productguid
				)
				<!--- TRV: return only data for "enabled" carriers --->
				and	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

				<cfif local.qGetPricingFilterOptions.currentRow lt local.qGetPricingFilterOptions.recordCount>
					union
				</cfif>
			</cfloop>

<!---
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Money Back' as filterLabel
			,	'<0' as filterValue
			,	1 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal < 0
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Free' as filterLabel
			,	'=0' as filterValue
			,	2 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal = 0
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Only 1&cent;' as filterLabel
			,	'=0.01' as filterValue
			,	3 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal = 0.01
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Less than $20' as filterLabel
			,	'>0:<=20' as filterValue
			,	4 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal > 0
			AND	p.price_#local.planType# - p.#local.planType#_rebateTotal <= 20
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'$20-$50' as filterLabel
			,	'>=20:<=50' as filterValue
			,	5 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal >= 20
			AND	p.price_#local.planType# - p.#local.planType#_rebateTotal <= 50
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'$50-$100' as filterLabel
			,	'>=50:<=100' as filterValue
			,	6 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal >= 50
			AND	p.price_#local.planType# - p.#local.planType#_rebateTotal <= 100
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'$100-$200' as filterLabel
			,	'>=100:<=200' as filterValue
			,	7 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal >= 100
			AND	p.price_#local.planType# - p.#local.planType#_rebateTotal <= 200
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'$200-$300' as filterLabel
			,	'>=200:<=300' as filterValue
			,	8 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal >= 200
			AND	p.price_#local.planType# - p.#local.planType#_rebateTotal <= 300
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'#variables.productClass#' as filterType
			,	'Pricing' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'price' as filterFieldName
			,	'checkbox' as filterControlType
			,	'$300+' as filterLabel
			,	'>=300' as filterValue
			,	9 as filterOrder
			,	COUNT(DISTINCT p.DeviceGuid) as filterItemCount
			,	0 as uniqueID
			from
				catalog.#variables.indexedViewName# p
			WHERE
				p.price_#local.planType# - p.#local.planType#_rebateTotal >= 300
			AND	EXISTS (
				SELECT
					1
				FROM
					catalog.ProductTag pt
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
				AND	pt.ProductGuid = p.DeviceGuid
			)
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			order by filterOrder
 --->
		</cfquery>

		<cfreturn local.qGetFilter_ProductPricing>
	</cffunction>

	<cffunction name="setCompareIds" access="remote" output="false" returntype="void">
		<cfargument name="productIds" type="string" required="true">
		<cfset var local = arguments>

		<cfparam name="session.#variables.filterType#Selections.compareIds" default="">

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.productIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#variables.filterType#Selections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="addCompareId" access="remote" output="false" returntype="void">
		<cfargument name="productId" type="string" required="true">
		<cfset var local = arguments>

		<cfparam name="session.#variables.filterType#Selections.compareIds" default="">
		<cfset local.compareIds = evaluate("session.#variables.filterType#Selections.compareIds")>

		<cfif not listFindNoCase(local.compareIds,local.productId)>
			<cfset local.compareIds = listAppend(local.compareIds,local.productId)>
		</cfif>

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.compareIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#variables.filterType#Selections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="removeCompareId" access="remote" output="false" returntype="void">
		<cfargument name="productId" type="string" required="false" default="">
		<cfset var local = arguments>

		<cfparam name="session.#variables.filterType#Selections.compareIds" default="">
		<cfset local.compareIds = evaluate("session.#variables.filterType#Selections.compareIds")>

		<cfif len(trim(local.productId))>
			<cfset local.compareIds = application.model.Util.listDelete(local.productId,local.compareIds) />
		</cfif>

		<!--- never let more than 5 productIds be used --->
		<cfset local.compareIds = application.model.Util.listMid(local.compareIds,1,5) />

		<!--- save the resulting list ids --->
		<cfset "session.#variables.filterType#Selections.compareIds" = local.compareIds>

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="setSort" access="remote" output="false" returntype="void">
		<cfargument name="sort" type="string" required="true">
		<cfset var local = arguments>
		<cfparam name="session.#variables.filterType#Selections.sort" default="price">
		<cfset "session.#variables.filterType#Selections.sort" = local.sort>

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="getSort" access="public" output="false" returntype="string">
		<cfparam name="session.#variables.filterType#Selections.sort" default="price">
		<cfreturn evaluate("session.#variables.filterType#Selections.sort")>
	</cffunction>

	<cffunction name="setActivationPrice" access="remote" output="false" returntype="void">
		<cfargument name="ActivationPrice" type="string" required="true" />
		<cfset var local = arguments />
		<cfparam name="session.#variables.filterType#Selections.ActivationPrice" default="new" />
		<cfset "session.#variables.filterType#Selections.ActivationPrice" = local.ActivationPrice />

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="getActivationPrice" access="public" output="false" returntype="string">
		<cfparam name="session.#variables.filterType#Selections.ActivationPrice" default="new" />
		<cfreturn evaluate("session.#variables.filterType#Selections.ActivationPrice") />
	</cffunction>

	<cffunction name="getDynamicTagFilters" access="public" output="false" returntype="struct">

		<cfset local = {} />
		<cfset local.dynamicTags = {} />
		<cfset local.priceGroupCode = 'ECN' />
		
		<!--- Determine user has selected a price group --->
		<cfif listFind( getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions'), '32' )>
			<cfset local.priceGroupCode = 'ECN' />
		<cfelseif listFind( getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '33' )>
			<cfset local.priceGroupCode = 'ECU' />
		<cfelseif listFind( getUserSelectedFilterValuesByFieldName(fieldName = 'planType'), '34' )>
			<cfset local.priceGroupCode = 'ECA' />
		</cfif>

		<cfloop list="#getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions')#" index="local.iFilterOption">
			<cfquery name="local.qFilterOption" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		fo.FilterGroupId, REPLACE(fo.DynamicTag, '$pricegroupcode$', '#local.priceGroupCode#') AS DynamicTag
				FROM		catalog.FilterOption fo WITH (NOLOCK)
				INNER JOIN	catalog.FilterGroup fg WITH (NOLOCK) ON fg.FilterGroupId = fo.FilterGroupId AND fg.Active = 1
				WHERE
					fo.FilterOptionId =	<cfqueryparam value="#local.iFilterOption#" cfsqltype="cf_sql_integer" />
					AND	fo.Active =	1
			</cfquery>

			<cfif local.qFilterOption.recordCount and len(trim(local.qFilterOption.dynamicTag))>
				<cfif not structKeyExists(local.dynamicTags, local.qFilterOption.filterGroupId[local.qFilterOption.currentRow])>
					<cfset local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]] = arrayNew(1) />
				</cfif>

				<cfset arrayAppend(local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]], local.qFilterOption.dynamicTag) />
			</cfif>
		</cfloop>

		<cfreturn local.dynamicTags />
	</cffunction>
	