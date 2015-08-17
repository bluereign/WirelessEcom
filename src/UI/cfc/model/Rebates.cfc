<cfcomponent name="Rebates" output="false">

	<cffunction name="init" access="public" returntype="Rebates" output="false">

		<cfset this.dsn = application.dsn.wirelessAdvocates />

		<cfreturn this />
	</cffunction>

	<cffunction name="getProductInRebateFilter" access="public" returntype="query" output="false">
		<cfargument name="productGuid" required="false" type="string" />
		<cfargument name="productId" required="false" type="numeric" />
		<cfargument name="type" required="false" type="string" default="new" />

		<cfset var getProductInRebateFilterReturn = queryNew('dynamicTag, title, amount, rebateGuid, productGuid, url, displayType, description, specialInstructions') />
		<cfset var qry_getProductInRebateFilter = '' />
		<cfset var qry_getProduct = queryNew('undefined') />
		<cfset var productQuery = '' />

		<cfquery name="qry_getProductInRebateFilter" datasource="#this.dsn#">
			SELECT		fo.dynamicTag, r.Title, r.amount, r.url, r.displayType,
						r.description, r.specialInstructions
			FROM		catalog.FilterOption AS fo WITH (NOLOCK)
			INNER JOIN	catalog.FilterGroup AS fg WITH (NOLOCK)
					ON 	fg.FilterGroupId 		= 	fo.FilterGroupId
			INNER JOIN	catalog.RebateToFilter AS rbtf WITH (NOLOCK)
					ON 	rbtf.FilterGroupID 		= 	fg.FilterGroupID
					AND rbtf.FilterOptionId 	= 	fo.FilterOptionId
			INNER JOIN	catalog.Rebate AS r WITH (NOLOCK)
					ON 	r.RebateGuid 			= 	rbtf.RebateGuid
					AND	r.Type					=	<cfqueryparam value="#trim(arguments.type)#" cfsqltype="cf_sql_varchar" maxlength="25" />
					AND	r.Active				=	1
					AND	r.StartDate				<=	GETDATE()
					AND	r.EndDate				>=	GETDATE()
			ORDER BY	r.amount DESC, r.title
		</cfquery>

		<cfif qry_getProductInRebateFilter.recordCount>
			<cfloop query="qry_getProductInRebateFilter">
				<cfsavecontent variable="productQuery">
					<cfoutput>
					SELECT	p.productGuid
					FROM	catalog.product AS p WITH (NOLOCK)
					WHERE	1=1
						<cfif structKeyExists(arguments, 'productGuid')>
							AND	p.productGuid	=	'#trim(arguments.productGuid)#'
						</cfif>
						<cfif structKeyExists(arguments, 'productId')>
							AND	p.productId		=	#trim(arguments.productId)#
						</cfif>
						AND		p.productGuid	IN	(#trim(qry_getProductInRebateFilter.dynamicTag)#)
					</cfoutput>
				</cfsavecontent>

				<cfquery name="qry_getProduct" datasource="#this.dsn#">
					#trim(preserveSingleQuotes(productQuery))#
				</cfquery>

				<cfif qry_getProduct.recordCount>
					<cfset queryAddRow(getProductInRebateFilterReturn) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'dynamicTag', qry_getProductInRebateFilter.dynamicTag) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'title', trim(qry_getProductInRebateFilter.title[qry_getProductInRebateFilter.currentRow])) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'amount', val(qry_getProductInRebateFilter.amount[qry_getProductInRebateFilter.currentRow])) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'productGuid', trim(qry_getProduct.productGuid)) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'url', trim(qry_getProductInRebateFilter.url[qry_getProductInRebateFilter.currentRow])) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'displayType', trim(qry_getProductInRebateFilter.displayType[qry_getProductInRebateFilter.currentRow])) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'description', trim(qry_getProductInRebateFilter.description[qry_getProductInRebateFilter.currentRow])) />
					<cfset querySetCell(getProductInRebateFilterReturn, 'specialInstructions', trim(qry_getProductInRebateFilter.specialInstructions[qry_getProductInRebateFilter.currentRow])) />
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn getProductInRebateFilterReturn />
	</cffunction>

	<cffunction name="isCartEligibleForRebate" access="public" returntype="any" output="false">
		<cfargument name="rebateGuid" required="false" type="string" default="" />
		<cfargument name="productGuidList" required="false" type="string" default="" />
		<cfargument name="activationType" required="false" type="string" default="new" />

		<cfset var isCartEligibleForRebateReturn = false />
		<cfset var qry_isCartEligibleForRebate = '' />

		<cfif not len(trim(arguments.activationType))>
			<cfset arguments.activationType = 'new' />
		</cfif>

		<cfif len(trim(arguments.rebateGuid)) and len(trim(arguments.productGuidList))>

			<cfstoredproc procedure="catalog.isEligibleForRebate" datasource="#this.dsn#" debug="yes" returncode="yes">
				<cfprocparam type="in" cfsqltype="cf_sql_uniqueidentifier" value="#UCASE(trim(arguments.rebateGuid))#" dbvarname="@RebateGuid" />
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#UCASE(trim(arguments.productGuidList))#" dbvarname="@ProductList" />
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#trim(arguments.activationType)#" dbvarname="@ActivationType" />

				<cfprocparam type="out" cfsqltype="cf_sql_integer" variable="qry_isCartEligibleForRebate" dbvarname="@ResultOut" />
			</cfstoredproc>

			<cfif val(qry_isCartEligibleForRebate)>
				<cfset isCartEligibleForRebateReturn = true />
			</cfif>
		</cfif>

		<cfreturn isCartEligibleForRebateReturn />
	</cffunction>

	<cffunction name="getRebates" access="public" returntype="query" output="false">
		<cfargument name="rebateGuid" required="false" type="string" />

		<cfset var getRebatesReturn = '' />
		<cfset var qry_getRebates = '' />

		<cfquery name="qry_getRebates" datasource="#this.dsn#">
			SELECT	r.rebateGuid, r.title, r.amount, r.url, r.type, r.displayType,
					r.description, r.specialInstructions
			FROM	catalog.rebate AS r WITH (NOLOCK)
			WHERE	r.active 	=	1
				AND	r.startDate	<=	GETDATE()
				AND	r.endDate	>=	GETDATE()
				<cfif structKeyExists(arguments, 'rebateGuid') and len(trim(arguments.rebateGuid))>
					AND	r.rebateGuid	=	'#trim(arguments.rebateGuid)#'
				</cfif>
			ORDER BY	r.amount DESC, r.title
		</cfquery>

		<cfset getRebatesReturn = qry_getRebates />

		<cfreturn getRebatesReturn />
	</cffunction>

	<cffunction name="assignOrderToRebates" access="public" returntype="boolean" output="false">
		<cfargument name="orderId" required="true" type="numeric" />
		<cfargument name="rebateGuidList" required="true" type="string" />

		<cfset var assignOrderToRebatesReturn = false />
		<cfset var qry_assignOrderToRebates = '' />
		<cfset var rebateGuid = '' />

		<cfloop list="#trim(arguments.rebateGuidList)#" index="rebateGuid">
			<cftransaction>
				<cfquery name="qry_assignOrderToRebates" datasource="#this.dsn#">
					INSERT INTO salesOrder.orderToRebates
					(
						OrderToRebateGuid,
						OrderId,
						RebateGuid
					)
					VALUES
					(
						NEWID(),
						<cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#rebateGuid#" cfsqltype="cf_sql_uniqueidentifier" />
					)
				</cfquery>
			</cftransaction>
		</cfloop>

		<cfset assignOrderToRebatesReturn = true />

		<cfreturn assignOrderToRebatesReturn />
	</cffunction>
	
	<cffunction name="getActiveRebateSkus" access="public" returntype="string" output="false">

		<cfquery name="qActiveRebates" datasource="wirelessadvocates" cachedWithin="#CreateTimeSpan(0, 1, 0, 0)#">
			SELECT distinct sku FROM [cms].[Rebates] r
			INNER JOIN [cms].[RebateSkus] rs ON rs.RebateGuid = r.rebateGuid
			where getdate() BETWEEN StartDateTime AND EndDateTime AND r.active <> 0	
			ORDER BY SKU 
		</cfquery>
		
		<cfif qActiveRebates.recordcount gt 0>
			<cfreturn valuelist(qActiveRebates.sku) />
		<cfelse>
			<cfreturn "" />
		</cfif>
		
	
	</cffunction>


</cfcomponent>