<cfcomponent output="false" displayname="Accessory">

	<cffunction name="init" returntype="Accessory">
		<cfset variables.accessoryFilter = application.wirebox.getInstance("AccessoryFilter") />
		<cfreturn this />
	</cffunction>

	<cffunction name="getAll" returntype="query">
		<cfargument name="bActiveOnly" type="boolean" default="false">
		<cfargument name="bIncludeBundled" type="boolean" default="true">
		<cfargument name="DisplayNoInventoryItems" type="boolean" default="#application.wirebox.getInstance("ChannelConfig").getDisplayNoInventoryItems()#" required="false" />

		<cfset var local = structNew()>

		<cfquery name="local.qAllAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT  
				a.AccessoryGuid
				, a.ProductGuid
				, a.ProductId
				, a.product_id
				, a.GersSku
				, a.category_id
				, a.categoryName
				, a.group_id
				, a.pageTitle
				, a.summaryTitle
				, a.detailTitle
				, a.summaryDescription
				, a.detailDescription
        		, a.MetaKeywords
				, a.price_retail
				, a.price
				, a.price as price
				, a.CompanyGuid
				, a.ManufacturerName
				, a.UPC
				, a.QtyOnHand
				, a.DefaultSortRank
				, null as groupName
			FROM catalog.dn_Accessories a
			<cfif arguments.bActiveOnly>
				INNER JOIN catalog.Product prod
					ON a.AccessoryGuid = prod.ProductGuid
					AND prod.Active = 1
			</cfif>
			WHERE 1=1
			<cfif arguments.DisplayNoInventoryItems is false>
				and a.QtyOnHand > 0
			</cfif>	
			<cfif not arguments.bIncludeBundled>
				and not exists (
					select 1
					from catalog.ProductTag pt
					where pt.tag = 'freeaccessory'
					and pt.ProductGuid = a.AccessoryGuid
				)
			</cfif>
<!--- TODO: fix this once we figure out how we're handling Accessory categories
			order by
				categoryName
			,	groupTitle
--->
			ORDER BY DetailTitle
		</cfquery>

		<cfreturn local.qAllAccessories />
	</cffunction>
	
<!---	<cffunction name="getSearchable" returntype="query">
		<cfargument name="bActiveOnly" type="boolean" default="false">
		<cfargument name="bIncludeBundled" type="boolean" default="true">
		<cfset var local = structNew()>

		<cfquery name="local.qAllAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT  
				a.AccessoryGuid
				, a.ProductGuid
				, a.ProductId
				, a.product_id
				, a.GersSku
				, a.category_id
				, a.categoryName
				, a.group_id
				, a.pageTitle
				, a.summaryTitle
				, a.detailTitle
				, a.summaryDescription
				, a.detailDescription
        		, a.MetaKeywords
				, a.price_retail
				, a.price
				, a.price as price
				, a.CompanyGuid
				, a.ManufacturerName
				, a.UPC
				, a.QtyOnHand
				, a.DefaultSortRank
				, null as groupName
			FROM catalog.dn_Accessories a
			<cfif arguments.bActiveOnly>
				INNER JOIN catalog.Product prod
					ON a.AccessoryGuid = prod.ProductGuid
					AND prod.Active = 1					
			</cfif>
			WHERE 1=1
			<cfif arguments.bActiveOnly>
				and a.QtyOnHand > 0
			</cfif>
			<cfif not arguments.bIncludeBundled>
				and not exists (
					select 1
					from catalog.ProductTag pt
					where pt.tag = 'freeaccessory'
					and pt.ProductGuid = a.AccessoryGuid
					and a.QtyOnHand > 0
				)
			</cfif>
<!--- TODO: fix this once we figure out how we're handling Accessory categories
			order by
				categoryName
			,	groupTitle
--->
			ORDER BY DetailTitle
		</cfquery>

		<cfreturn local.qAllAccessories />
	</cffunction>
--->
	<cffunction name="getDetail" returntype="query">
		<cfargument name="product_id" type="string" required="true"> <!--- TRV: used "string" to support passing a list of ids (for compare page) --->
		<cfset var local = structNew()>

		<cfquery name="local.qGetAccessory" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				AccessoryGuid
				, ProductGuid
				, ProductId
				, product_id
				, GersSku
				, category_id
				, categoryName
				, group_id
				, pageTitle
				, summaryTitle
				, detailTitle
				, summaryDescription
				, detailDescription
				, price_retail
				, price
				, CompanyGuid
				, ManufacturerName
				, UPC
				, QtyOnHand
				, DefaultSortRank
			FROM catalog.dn_Accessories WITH (NOLOCK)
			WHERE 1=1
				AND	product_id IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#" list="true"> )
		</cfquery>

		<cfreturn local.qGetAccessory />
	</cffunction>
	
	<cffunction name="getByFilter" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="sort" type="string" default="price" />
		<cfargument name="idList" type="string" default="" />
		<cfargument name="associatedDeviceIdFilter" type="string" default="" />
		<cfargument name="notUniversal" type="boolean" default="false" />
		<cfargument name="excludeIdList" type="string" default="" />
		<cfargument name="DisplayNoInventoryItems" type="boolean" default="#application.wirebox.getInstance("ChannelConfig").getDisplayNoInventoryItems()#" required="false" />

		<cfset var local = {} />

		<cfif not len(arguments.idList)>

			<cfset local.dynamicTags = {} />
			
			<cfset local.loopList = variables.accessoryFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions') />
		
			<cfloop list="#local.loopList#" index="local.iFilterOption">
				<cfif local.iFilterOption neq 'on'>
					<cfquery name="local.qFilterOption" datasource="#application.dsn.wirelessAdvocates#">
						SELECT		fo.filterGroupId, dynamicTag
						FROM		catalog.filterOption AS fo WITH (NOLOCK)
						INNER JOIN	catalog.filterGroup AS fg WITH (NOLOCK) ON fg.filterGroupId = fo.filterGroupId
								AND	fg.active	=	1
						WHERE		fo.filterOptionId = #local.iFilterOption#
								AND	fo.active = 1
					</cfquery>
	
					<cfif local.qFilterOption.recordCount and len(trim(local.qFilterOption.dynamicTag))>
						<cfif not structKeyExists(local.dynamicTags, local.qFilterOption.filterGroupId[local.qFilterOption.currentRow])>
							<cfset local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]] = arrayNew(1) />
						</cfif>
	
						<cfset arrayAppend(local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]], local.qFilterOption.dynamicTag) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfquery name="local.qAccessoriesByFilter" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.AccessoryGuid
				, p.ProductGuid
				, p.ProductId
				, p.product_id
				, p.GersSku
				, p.category_id
				, p.categoryName
				, p.group_id
				, p.pageTitle
				, p.summaryTitle
				, p.detailTitle
				, p.summaryDescription
				, p.detailDescription
				, p.price_retail
				, p.price
				, p.CompanyGuid
				, p.ManufacturerName
				, p.UPC
				, p.QtyOnHand
				, p.DefaultSortRank
			FROM catalog.dn_accessories AS p WITH (NOLOCK)
			<cfif Len(arguments.associatedDeviceIdFilter)>
				INNER JOIN catalog.AccessoryForDevice ad ON ad.AccessoryGuid = p.AccessoryGuid
				INNER JOIN catalog.Device d ON d.DeviceGuid = ad.DeviceGuid
				INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid 
					AND dp.ProductId = <cfqueryparam value="#arguments.associatedDeviceIdFilter#" cfsqltype="cf_sql_integer" />
			</cfif>
			WHERE	1 = 1
				AND p.productGuid NOT IN (SELECT pt.ProductGuid FROM catalog.ProductTag AS pt WITH (NOLOCK) WHERE pt.Tag = 'hide' OR pt.Tag = 'autohide')
			<cfif !arguments.DisplayNoInventoryItems>
				AND p.QtyOnHand > 0
			</cfif>
			<cfif len(arguments.excludeIdList)>
				AND	p.productId NOT IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.excludeIdList#" list="true" /> )
			</cfif>
			<cfif len(arguments.idList)>
				AND	p.productId IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.idList#" list="true" /> )
			<cfelse>
				<cfloop collection="#local.dynamicTags#" item="local.iFilterGroupId">
					AND (
						1 = 0
						<cfloop from="1" to="#arrayLen(local.dynamicTags[local.iFilterGroupId])#" index="local.iDynamicTag">
							OR EXISTS (
								SELECT	1
								FROM	(
										<cfset local.sql = local.dynamicTags[local.iFilterGroupId][local.iDynamicTag] />
										#trim(preserveSingleQuotes(local.sql))#
									) AS prod
								WHERE	prod.ProductGuid = p.ProductGuid
							)
						</cfloop>
					)
				</cfloop>
				
				<cfif arguments.notUniversal>
					AND NOT EXISTS (
						SELECT	1
						FROM	catalog.productTag AS pt WITH (NOLOCK)
						WHERE	pt.tag	=	'universal'
							AND	pt.productGuid = p.productGuid
					)
				</cfif>
				AND NOT EXISTS (
					SELECT	1
					FROM	catalog.productTag AS pt WITH (NOLOCK)
					WHERE	pt.tag	=	'freeaccessory'
						AND	pt.productGuid = p.productGuid
				)
			</cfif>

			<cfswitch expression="#arguments.sort#">
				<cfcase value="popular">
					ORDER BY p.defaultSortRank ASC
				</cfcase>
				<cfcase value="PriceAsc,PriceDesc">
					ORDER BY p.price <cfif arguments.Sort eq 'PriceAsc'>ASC<cfelse>DESC</cfif>
				</cfcase>
				<cfcase value="NameAsc,NameDesc">
					ORDER BY p.summaryTitle <cfif arguments.Sort eq 'NameAsc'>ASC<cfelse>DESC</cfif>
				</cfcase>
				<cfdefaultcase>
					ORDER BY p.price ASC
				</cfdefaultcase>
			</cfswitch>
		</cfquery>

		<cfreturn local.qAccessoriesByFilter />
	</cffunction>
	
	<cffunction name="getByBrand" access="public" returntype="query" output="false">
		<cfargument name="brandId" type="any" />

		<cfset var local = {} />
		<cfset local.dynamicTags = {} />

		<cfquery name="local.qFilterOption" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		fo.filterGroupId, dynamicTag
			FROM		catalog.filterOption AS fo WITH (NOLOCK)
			INNER JOIN	catalog.filterGroup AS fg WITH (NOLOCK) ON fg.filterGroupId = fo.filterGroupId
					AND	fg.active	=	1
			WHERE		fo.filterOptionId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brandId#" />
					AND	fo.active = 1
		</cfquery>

		<cfif local.qFilterOption.recordCount and len(trim(local.qFilterOption.dynamicTag))>
			<cfif not structKeyExists(local.dynamicTags, local.qFilterOption.filterGroupId[local.qFilterOption.currentRow])>
				<cfset local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]] = arrayNew(1) />
			</cfif>

			<cfset arrayAppend(local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]], local.qFilterOption.dynamicTag) />
		</cfif>

		<cfquery name="local.qAccessoriesByFilter" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.AccessoryGuid
				<!--- , p.ProductGuid --->
				, p.ProductId
				<!--- , p.product_id
				, p.GersSku --->
				, p.category_id
				, p.categoryName
				, p.group_id
				<!--- , p.pageTitle --->
				, p.summaryTitle
				<!--- , p.detailTitle
				, p.summaryDescription
				, p.detailDescription
				, p.price_retail
				, p.price
				, p.CompanyGuid --->
				, p.ManufacturerName
				<!--- , p.UPC --->
				, p.QtyOnHand
				, p.DefaultSortRank
			FROM catalog.dn_accessories AS p WITH (NOLOCK)
<!--- 
			<cfif Len(arguments.associatedDeviceIdFilter)>
				INNER JOIN catalog.AccessoryForDevice ad ON ad.AccessoryGuid = p.AccessoryGuid
				INNER JOIN catalog.Device d ON d.DeviceGuid = ad.DeviceGuid
				INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid 
					AND dp.ProductId = <cfqueryparam value="#arguments.associatedDeviceIdFilter#" cfsqltype="cf_sql_integer" />
			</cfif>
 --->
			WHERE	1 = 1
<!--- 
			<cfif len(arguments.idList)>
				AND	p.productId IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.idList#" list="true" /> )
			<cfelse>
 --->
				<cfloop collection="#local.dynamicTags#" item="local.iFilterGroupId">
					AND (
						1 = 0
						<cfloop from="1" to="#arrayLen(local.dynamicTags[local.iFilterGroupId])#" index="local.iDynamicTag">
							OR EXISTS (
								SELECT	1
								FROM	(
										<cfset local.sql = local.dynamicTags[local.iFilterGroupId][local.iDynamicTag] />
										#trim(preserveSingleQuotes(local.sql))#
									) AS prod
								WHERE	prod.ProductGuid = p.ProductGuid
							)
						</cfloop>
					)
				</cfloop>
				AND NOT EXISTS (
					SELECT	1
					FROM	catalog.productTag AS pt WITH (NOLOCK)
					WHERE	pt.tag	=	'freeaccessory'
						AND	pt.productGuid = p.productGuid
				)
			<!--- </cfif> --->

			<!--- <cfswitch expression="#arguments.sort#">
				<cfcase value="PriceAsc,PriceDesc">
					ORDER BY p.price <cfif arguments.Sort eq 'PriceAsc'>ASC<cfelse>DESC</cfif>
				</cfcase>
				<cfcase value="NameAsc,NameDesc">
					ORDER BY p.summaryTitle <cfif arguments.Sort eq 'NameAsc'>ASC<cfelse>DESC</cfif>
				</cfcase>
				<cfdefaultcase> --->
					ORDER BY p.price ASC
				<!--- </cfdefaultcase>
			</cfswitch> --->
		</cfquery>

		<cfreturn local.qAccessoriesByFilter />
	</cffunction>
	
	<cffunction name="getFeatures" returntype="any">
		<cfargument name="accessoryID" required="true"> <!--- should support a comma-delimited list of ids for the compare page --->
		<cfset var local = structNew()>

		<cfset local.getFeatures = application.model.PropertyManager.getPropertiesByProductId(this.getAccessoryGuidByProductId(arguments.accessoryID),"features")>
		<cfreturn local.getFeatures>
	</cffunction>

	<cffunction name="getSpecs" returntype="any">
		<cfargument name="accessoryID" required="true"> <!--- should support a comma-delimited list of ids for the compare page --->
		<cfset var local = structNew()>

		<cfset local.getSpecs = application.model.PropertyManager.getPropertiesByProductId(this.getAccessoryGuidByProductId(arguments.accessoryID),"specifications")>
		<cfreturn local.getSpecs>
	</cffunction>

	<cffunction name="getCompareData" returntype="any">
		<cfargument name="accessoryID" required="true"> <!--- should support a comma-delimited list of ids for the compare page --->
		<cfset var local = structNew()>

		<cfset local.getCompareData = application.model.PropertyManager.getComparePropertiesByProductId(arguments.accessoryID)>

		<cfreturn local.getCompareData>
	</cffunction>

	<cffunction name="getAccessoryGuidByProductId" returntype="string">
		<cfargument name="productID" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = 0>

		<cfquery name="local.qAccessoryGuid" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				AccessoryGuid
			FROM
				catalog.dn_Accessories
			WHERE
				product_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#">
		</cfquery>
		<cfif local.qAccessoryGuid.recordCount>
			<cfset local.return = local.qAccessoryGuid.AccessoryGuid>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getAllFreeAccessoryProductIds" returntype="string">
		<cfset var local = structNew()>
		<cfset local.list = "">

		<cfquery name="local.qAllFreeAccessories" datasource="#application.dsn.wirelessAdvocates#">
			select
				a.ProductId
			from
				catalog.dn_Accessories a
			where exists (
				select
					1
				from
					catalog.DeviceFreeAccessory dfa
				where
					dfa.ProductGuid = a.AccessoryGuid
			)
		</cfquery>
		<cfif local.qAllFreeAccessories.recordCount>
			<cfset local.list = valueList(local.qAllFreeAccessories.ProductId)>
		</cfif>
		<cfreturn local.list>
	</cffunction>

	<cffunction name="getPrice" access="public" output="false" returntype="numeric">
		<cfargument name="productId" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.price = 0>
		<cfquery name="local.qGetPrice" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				price
			FROM
				catalog.dn_Accessories
			WHERE
				ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#">
		</cfquery>
		<cfif local.qGetPrice.recordCount>
			<cfset local.price = local.qGetPrice.price>
		</cfif>
		<cfreturn local.price>
	</cffunction>

	<cffunction name="isBundledAccessory" access="public" output="false" returntype="boolean">
		<cfargument name="productId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfquery name="local.qIsAccessoryBundled" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				pt.ProductGuid
			FROM
				catalog.ProductTag pt
				INNER JOIN catalog.Product p
					on pt.ProductGuid = p.ProductGuid
			WHERE
				pt.Tag = <cfqueryparam cfsqltype="cf_sql_char" value="freeaccessory">
			AND p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#">
		</cfquery>
		<cfif local.qIsAccessoryBundled.recordCount>
			<cfset local.return = true>
		</cfif>
		<cfreturn local.return>
	</cffunction>
</cfcomponent>