<cfcomponent output="false" displayname="PlanFilter">

	<cffunction name="init" returntype="PlanFilter">
		<cfargument name="queryCacheSpan" default="#createTimeSpan(0,0,10,0)#" required="false" />
		<cfset variables.queryCacheSpan = arguments.queryCacheSpan />
		<cfreturn this />
	</cffunction>

	<cffunction name="getFilterData" returntype="any">
		<cfset var local = structNew()>

		<!--- this variable controls whether filter with a "0" product count will be included or ignored --->
		<cfset local.bSuppressZeroCountFilters = true>

		<cfset local.objCache = createObject('component','cfc.model.Cache').init()>
		<cfset local.cacheKey = "planFilter,filterData">

		<cfset local.stcCache = local.objCache.get(listToArray(local.cacheKey))>

		<!--- TRV: disabling caching support for now
		<cfif local.stcCache.isValid>
			<cfset local.filterData = local.stcCache.cacheData>
		<cfelse>
		--->
			<cfset local.producttype = "plan">
			<cfset local.productview = "catalog.dn_Plans">

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

						<!---Set prodcount to 1 for now--->
						<cfset local.qFilterOptionProducts.Prodcount = 1>
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

<!--- TRV: disabling caching support for now
			<cfset local.stcCache = local.objCache.save(listToArray(local.cacheKey),local.aFilterData,now()+createTimeSpan(0,0,20,0))>

			<cfset local.filterData = local.stcCache.cacheData>
		</cfif>
--->

		<cfset local.filterData = local.aFilterData>

		<cfreturn local.filterData>
	</cffunction>

	<cffunction name="getUserSelectedFilterValuesByFieldName" returntype="string">
		<cfargument name="fieldName" type="variableName" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfif structKeyExists(session.planFilterSelections,arguments.fieldName)>
			<cfset local.return = session.planFilterSelections[arguments.fieldName]>
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
		<cfif not structKeyExists(arguments.formFields,"compareIDs") and not structKeyExists(arguments.formFields,"filter.compareIDs") and structKeyExists(session.planFilterSelections,"compareIDs")>
			<cfset local.filterSelections.compareIDs = session.planFilterSelections.compareIDs>
		</cfif>
		<!--- TRV: adding code to preserve the sort --->
		<cfif not structKeyExists(arguments.formFields,"sort") and not structKeyExists(arguments.formFields,"filter.sort") and structKeyExists(evaluate("session.planFilterSelections"),"sort")>
			<cfset local.filterSelections.sort = session.planFilterSelections.sort>
		</cfif>
		<cfset "session.planFilterSelections" = duplicate(local.filterSelections)>
		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="getPlanTypesByCartDevice" returntype="string">
		<cfset var local = structNew()>
		<cfset local.planTypes = "">
		<cfset local.bPhonePlans = false>
		<cfset local.bDataPlans = false>
<!--- TRV: commenting this for now since I think it makes much less sense for us on MVC-2 to be hiding "data" plans when phones are selected
		<cfif isDefined("session.cart") and isStruct(session.cart) and session.cart.getCurrentLine() and arrayLen(session.cart.getLines()) gte session.cart.getCurrentLine()>
			<cfset local.cartLines = session.cart.getLines()>
			<cfset local.thisLine = local.cartLines[session.cart.getCurrentLine()]>
			<cfif local.thisLine.getPhone().hasBeenSelected()>
				<cfset local.thisDeviceID = local.thisLine.getPhone().getProductID()>
				<cfset local.thisDeviceType = application.model.Product.getProductTypeIDByProductID(local.thisDeviceID)>
				<cfif local.thisDeviceType eq "Device">
					<cfset local.bPhonePlans = true>
					<cfset local.bDataPlans = false>
				<cfelse>
					<cfset local.bPhonePlans = false>
					<cfset local.bDataPlans = true>
				</cfif>
			</cfif>
		</cfif>

		<cfif local.bPhonePlans>
			<cfset local.planTypes = listAppend(local.planTypes,"individual,family")>
		</cfif>
		<cfif local.bDataPlans>
			<cfset local.planTypes = listAppend(local.planTypes,"data")>
		</cfif>
--->
		<cfset local.planTypes = "individual,family,data">

		<cfreturn local.planTypes>
	</cffunction>

	<cffunction name="getPhones" returntype="query">
		<cfset var local = structNew()>
		<cfset local.zipcode = "">
		<cfif application.model.CartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode()>
			<cfset local.zipcode = trim(listFirst(local.zipcode,"-"))>
		</cfif>

		<cfquery name="local.qGetFilter_PlanTypes" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'plan' as filterType
			,	'PlanPhone' as filterGroupLabel
			,	0 as filterGroupOrder
			,	'phoneID' as filterFieldName
			,	'radio' as filterControlType
			,	ph.summaryTitle as filterLabel
			,	ph.phoneID as filterValue
			,	1 as filterOrder --ROW_NUMBER() over (order by ph.summ) as filterOrder
			,	filterItemCount = (
				SELECT count(DISTINCT p.planName)
				FROM
					catalog.dn_Plans p
				WHERE exists (
					SELECT
						1
					FROM
						ctproductprice pp
						inner join ctProduct ctp
							on ctp.ProductID = pp.PlanID
					WHERE
						pp.productid = ph.phoneID
					AND	ctp.ProductTypeCode = 'PLAN'
					AND	ctp.Active = '1'
					AND ctp.Name = p.planName
				)
			)
			,	0 as uniqueID
			from
				catalog.dn_Phones ph
			where
				ph.phoneID = 95672
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			order by filterOrder
		</cfquery>

		<cfreturn local.qGetFilter_PlanTypes>
	</cffunction>

	<cffunction name="getPlanTypes" returntype="query">
		<cfset var local = structNew()>
		<cfset local.zipcode = "">
		<cfif application.model.CartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode()>
			<cfset local.zipcode = trim(listFirst(local.zipcode,"-"))>
		</cfif>

		<cfset local.planTypes = getPlanTypesByCartDevice()>
		<!--- only overwrite the session plan filter if there is something better in the cart --->
<!--- 		<cfif len(local.planTypes)>
			<cfset session.planFilterSelections.planType = local.planTypes>
		</cfif> --->
		 

		<cfset local.needUnion = false>

		<cfquery name="local.qGetFilter_PlanTypes" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
<!--- 			<cfif not len(trim(local.planTypes)) or listFindNoCase(local.planTypes,"individual")> --->
				<cfset local.needUnion = true>
				<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
				select
					'plan' as filterType
				,	'Plan Type' as filterGroupLabel
				,	1 as filterGroupOrder
				,	'planType' as filterFieldName
				,	'checkbox' as filterControlType
				,	'Individual' as filterLabel
				,	'individual' as filterValue
				,	1 as filterOrder
				,	COUNT(DISTINCT p.planName) as filterItemCount
				,	0 as uniqueID
				from
					catalog.dn_Plans p
				where
					p.planType = 'individual'
				<!--- if we have a zipcode --->
				<cfif len(trim(local.zipcode))>
				AND EXISTS (
					select
						1
					from
						catalog.dn_Plans p2
						inner join catalog.RateplanMarket rm
							on p2.RateplanGuid = rm.RateplanGuid
						inner join catalog.ZipCodeMarket zm
							on rm.MarketGuid = zm.MarketGuid
					where
						zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
					and	p2.CarrierBillCode = p.CarrierBillCode
				)
				</cfif>
				<!--- TRV: return only data for "enabled" carriers --->
				AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
<!--- 			</cfif> --->

<!--- 			<cfif not len(trim(local.planTypes)) or listFindNoCase(local.planTypes,"family")> --->
				<cfif local.needUnion>
					union
				</cfif>

				<cfset local.needUnion = true>
				select
					'plan' as filterType
				,	'Plan Type' as filterGroupLabel
				,	1 as filterGroupOrder
				,	'planType' as filterFieldName
				,	'checkbox' as filterControlType
				,	'Family' as filterLabel
				,	'family' as filterValue
				,	2 as filterOrder
				,	COUNT(DISTINCT p.planName) as filterItemCount
				,	0 as uniqueID
				from
					catalog.dn_Plans p
				where
					p.planType = 'family'
				<!--- if we have a zipcode --->
				<cfif len(trim(local.zipcode))>
				AND EXISTS (
					select
						1
					from
						catalog.dn_Plans p2
						inner join catalog.RateplanMarket rm
							on p2.RateplanGuid = rm.RateplanGuid
						inner join catalog.ZipCodeMarket zm
							on rm.MarketGuid = zm.MarketGuid
					where
						zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
					and	p2.CarrierBillCode = p.CarrierBillCode
				)
				</cfif>
				<!--- TRV: return only data for "enabled" carriers --->
				AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
<!--- 			</cfif> --->

<!--- 			<cfif not len(trim(local.planTypes)) or listFindNoCase(local.planTypes,"data")> --->
				<cfif local.needUnion>
					union
				</cfif>

				<cfset local.needUnion = true>
				select
					'plan' as filterType
				,	'Plan Type' as filterGroupLabel
				,	1 as filterGroupOrder
				,	'planType' as filterFieldName
				,	'checkbox' as filterControlType
				,	'Data' as filterLabel
				,	'data' as filterValue
				,	3 as filterOrder
				,	COUNT(DISTINCT p.planName) as filterItemCount
				,	0 as uniqueID
				from
					catalog.dn_Plans p
				where
					p.planType = 'data'
				<!--- if we have a zipcode --->
				<cfif len(trim(local.zipcode))>
				AND EXISTS (
					select
						1
					from
						catalog.dn_Plans p2
						inner join catalog.RateplanMarket rm
							on p2.RateplanGuid = rm.RateplanGuid
						inner join catalog.ZipCodeMarket zm
							on rm.MarketGuid = zm.MarketGuid
					where
						zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
					and	p2.CarrierBillCode = p.CarrierBillCode
				)
				</cfif>
				<!--- TRV: return only data for "enabled" carriers --->
				AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
<!--- 			</cfif> --->

			order by filterOrder
		</cfquery>

		<cfreturn local.qGetFilter_PlanTypes>
	</cffunction>

	<cffunction name="getPlanCarriers" returntype="query">
		<cfset var local = structNew()>
		<cfset local.zipcode = "">
		<cfif application.model.CartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode()>
			<cfset local.zipcode = trim(listFirst(local.zipcode,"-"))>
		</cfif>

		<cfquery name="local.qGetFilter_PlanCarriers" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'plan' as filterType
			,	'Carrier' as filterGroupLabel
			,	2 as filterGroupOrder
			,	'carrierID' as filterFieldName
			,	'checkbox' as filterControlType
			,	p.CompanyName as filterLabel
			,	CONVERT(varchar(50), p.carrierID) as filterValue
			,	ROW_NUMBER() over (order by p.CompanyName) as filterOrder
			,	COUNT(DISTINCT p.CarrierBillCode) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				1=1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
			group by
				p.carrierID
			,	p.CompanyName
			order by p.CompanyName asc
		</cfquery>

		<cfreturn local.qGetFilter_PlanCarriers>
	</cffunction>

	<cffunction name="getPlanMinutes" returntype="query">
		<cfset var local = structNew()>
		<cfset local.zipcode = "">
		<cfif application.model.CartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode()>
			<cfset local.zipcode = trim(listFirst(local.zipcode,"-"))>
		</cfif>

		<cfquery name="local.qGetFilter_PlanMinutes" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'plan' as filterType
			,	'Minutes' as filterGroupLabel
			,	3 as filterGroupOrder
			,	'minutes_anytime' as filterFieldName
			,	'checkbox' as filterControlType
			,	'0 - 500' as filterLabel
			,	'>=0:<=500' as filterValue
			,	1 as filterOrder
			,	COUNT(DISTINCT p.ProductId) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.minutes_anytime >= 0
			and p.minutes_anytime <= 500
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Minutes' as filterGroupLabel
			,	3 as filterGroupOrder
			,	'minutes_anytime' as filterFieldName
			,	'checkbox' as filterControlType
			,	'500 - 1000' as filterLabel
			,	'>=500:<=1000' as filterValue
			,	2 as filterOrder
			,	COUNT(DISTINCT p.ProductId) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.minutes_anytime >= 500
			and p.minutes_anytime <= 1000
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Minutes' as filterGroupLabel
			,	3 as filterGroupOrder
			,	'minutes_anytime' as filterFieldName
			,	'checkbox' as filterControlType
			,	'1000 - 2000' as filterLabel
			,	'>=1000:<=2000' as filterValue
			,	3 as filterOrder
			,	COUNT(DISTINCT p.ProductId) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.minutes_anytime >= 1000
			and p.minutes_anytime <= 2000
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Minutes' as filterGroupLabel
			,	3 as filterGroupOrder
			,	'minutes_anytime' as filterFieldName
			,	'checkbox' as filterControlType
			,	'2000 - 4000' as filterLabel
			,	'>=2000:<=4000' as filterValue
			,	4 as filterOrder
			,	COUNT(DISTINCT p.ProductId) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.minutes_anytime >= 2000
			and p.minutes_anytime <= 4000
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Minutes' as filterGroupLabel
			,	3 as filterGroupOrder
			,	'minutes_anytime' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited' as filterLabel
			,	'>=99999' as filterValue
			,	5 as filterOrder
			,	COUNT(DISTINCT p.ProductId) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.minutes_anytime >= 99999
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			order by filterOrder
		</cfquery>

		<cfreturn local.qGetFilter_PlanMinutes>
	</cffunction>

	<cffunction name="getPlanFeatures" returntype="query">
		<cfset var local = structNew()>
		<cfset local.zipcode = "">
		<cfif application.model.CartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode()>
			<cfset local.zipcode = trim(listFirst(local.zipcode,"-"))>
		</cfif>

		<cfquery name="local.qGetFilter_PlanFeatures" datasource="#application.dsn.wirelessAdvocates#" cachedwithin="#variables.queryCacheSpan#">
			<!--- TRV: could consider caching this, but record set is likely small enough to avoid that for now --->
			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'unlimited_offpeak' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited Off-Peak' as filterLabel
			,	'1' as filterValue
			,	1 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.unlimited_offpeak = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'unlimited_mobtomob' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited Mobile to Mobile' as filterLabel
			,	'1' as filterValue
			,	2 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				dn_Plans p
			where
				p.unlimited_mobtomob = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'unlimited_friendsandfamily' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited Friends and Family' as filterLabel
			,	'1' as filterValue
			,	3 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				dn_Plans p
			where
				p.unlimited_friendsandfamily = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'unlimited_data' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited Data' as filterLabel
			,	'1' as filterValue
			,	4 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				dn_Plans p
			where
				p.unlimited_data = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'unlimited_textmessaging' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Unlimited Text Messaging' as filterLabel
			,	'1' as filterValue
			,	5 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				dn_Plans p
			where
				p.unlimited_textmessaging = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'free_longdistance' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Free Long Distance' as filterLabel
			,	'1' as filterValue
			,	6 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				dn_Plans p
			where
				p.free_longdistance = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			union

			select
				'plan' as filterType
			,	'Features' as filterGroupLabel
			,	4 as filterGroupOrder
			,	'free_roaming' as filterFieldName
			,	'checkbox' as filterControlType
			,	'Free Roaming' as filterLabel
			,	'1' as filterValue
			,	7 as filterOrder
			,	COUNT(DISTINCT p.planName) as filterItemCount
			,	0 as uniqueID
			from
				catalog.dn_Plans p
			where
				p.free_roaming = 1
			<!--- if we have a zipcode --->
			<cfif len(trim(local.zipcode))>
			AND EXISTS (
				select
					1
				from
					catalog.dn_Plans p2
					inner join catalog.RateplanMarket rm
						on p2.RateplanGuid = rm.RateplanGuid
					inner join catalog.ZipCodeMarket zm
						on rm.MarketGuid = zm.MarketGuid
				where
					zm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
				and	p2.CarrierBillCode = p.CarrierBillCode
			)
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )

			order by filterOrder
		</cfquery>

		<cfreturn local.qGetFilter_PlanFeatures>
	</cffunction>

	<cffunction name="setCompareIds" access="remote" output="false" returntype="void">
		<cfargument name="productIds" type="string" required="true">
		<cfargument name="productClass" type="string" default="plan">
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
		<cfargument name="productClass" type="string" default="plan">
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
		<cfargument name="productClass" type="string" default="plan">
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
		<cfparam name="session.planFilterSelections.sort" default="price">
		<cfset "session.planFilterSelections.sort" = local.sort>

		<!--- throw a flag to indicate that we've changed the user's session data --->
		 
	</cffunction>

	<cffunction name="getSort" access="public" output="false" returntype="string">
		<cfparam name="session.planFilterSelections.sort" default="price">
		<cfreturn session.planFilterSelections.sort>
	</cffunction>

</cfcomponent>