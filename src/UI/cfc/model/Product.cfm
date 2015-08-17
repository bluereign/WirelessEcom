<cffunction name="getByBrand" access="public" returntype="query" output="false">
	<cfargument name="brandId" type="any" />
	<cfargument name="bActiveOnly" type="boolean" default="false">
	<cfargument name="bHasAccessories" type="boolean" default="false">
	<cfargument name="bSortBy" type="any" default="">
	
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
	
	<cfquery name="local.qProductsByBrand" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	
			p.DeviceGuid
			, p.ProductGuid
			, p.phoneID
			, p.product_id
			, p.ProductID
			, p.summaryTitle
			, p.detailTitle
			, p.manufacturerGuid
			, p.manufacturerName
			, p.QtyOnHand
			, p.DefaultSortRank
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'smartphone' AND pt.ProductGuid = p.ProductGuid), 0))) isSmartPhone		
			, CASE
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'MVM' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'Coupon'
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'Closeout' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'Closeout'
				WHEN DATEDIFF( d, CONVERT(DATETIME, p.ReleaseDate), GETDATE() )	< 15 THEN 'NewRelease'
				ELSE NULL
			  END BadgeType
			, (SELECT TOP 1 pp.Value FROM catalog.Property pp WITH (NOLOCK) WHERE pp.Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND pp.ProductGuid = p.ProductGuid) DeviceType
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPNEW' AND pt.ProductGuid = p.ProductGuid), 0)) IsNewPriceMap
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPUPGRADE' AND pt.ProductGuid = p.ProductGuid), 0)) IsUpgradePriceMap
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPAAL' AND pt.ProductGuid = p.ProductGuid), 0)) IsAddalinePriceMap
		FROM catalog.#variables.indexedViewName# AS p WITH (NOLOCK)
		<cfif arguments.bActiveOnly>
			INNER JOIN catalog.Product prod WITH (NOLOCK)
				ON p.ProductGuid = prod.ProductGuid
				AND prod.Active = 1
		</cfif>

		WHERE	1=1
		<cfloop collection="#local.dynamicTags#" item="local.iFilterGroupId">
			AND (
				1 = 0
				<cfloop from="1" to="#arrayLen(local.dynamicTags[local.iFilterGroupId])#" index="local.iDynamicTag">
					OR EXISTS (
						SELECT	1
						FROM (
							<cfset local.sql = local.dynamicTags[local.iFilterGroupId][local.iDynamicTag] />
							#preserveSingleQuotes(local.sql)#
						) AS 	prod
						WHERE	prod.ProductGuid = p.ProductGuid
					)
				</cfloop>
			)
		</cfloop>
		<cfif arguments.bHasAccessories>
			AND EXISTS (
				SELECT 1 
				FROM catalog.AccessoryForDevice afd 
				WHERE afd.DeviceGuid = p.ProductGuid
			)
		</cfif>
		ORDER BY
		<cfif Len(arguments.bSortBy)>
			#arguments.bSortBy#
		<cfelse>
			 p.defaultSortRank
		</cfif>
	</cfquery>

	<cfreturn local.qProductsByBrand />
</cffunction>

<cffunction name="getByFilter" access="public" returntype="query" output="false">
	<cfargument name="Filter" type="struct" default="#structNew()#" />
	<cfargument name="Sort" type="string" default="popular" />
	<cfargument name="IdList" type="string" default="" /> <!--- Empty on product listing page --->
	<cfargument name="AllowHidden" required="false" type="boolean" default="false" />
	<cfargument name="ActivationPrice" required="false" type="string" default="new" />
	<cfargument name="DisplayNoInventoryItems" type="boolean" default="#application.wirebox.getInstance("ChannelConfig").getDisplayNoInventoryItems()#" required="false" />
	<cfargument name="DisplayZeroPricedItems" type="boolean" default="#application.wirebox.getInstance("ChannelConfig").getDisplayZeroPricedItems()#" required="false" />

	<cfset var local = {} />
	<cfset local.dynamicTags = arguments.Filter />
	<cfset local.planType = arguments.ActivationPrice />

	<cfscript>
		channelConfig = application.wirebox.getInstance("ChannelConfig");
	</cfscript>
	
	<cfquery name="local.qProductsByFilter" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			p.DeviceGuid
			, p.ProductGuid
			, p.PhoneID
			, p.Product_id
			, p.ProductID
			, p.GersSku
			, p.PageTitle
			, p.SummaryTitle
			, p.DetailTitle
			, p.CarrierId
			, p.CarrierName
			, p.ManufacturerGuid
			, p.ManufacturerName
			, p.IsAvailableInWarehouse
			, p.IsAvailableOnline
			, p.bFreeAccessory
			, p.SummaryDescription
			, p.DetailDescription
			, p.MetaKeywords
			, p.MetaDescription
			, p.ReleaseDate
			, p.Prepaid
			, p.TypeID
			, p.price_retail
			, p.price_new
			, p.price_upgrade
			, p.price_addaline
			, p.price_nocontract
        	, p.NewPriceAfterRebate
        	, p.UpgradePriceAfterRebate
        	, p.AddALinePriceAfterRebate
			, p.FinancedFullRetailPrice
			, p.FinancedMonthlyPrice12
			, p.FinancedMonthlyPrice18
			, p.FinancedMonthlyPrice24
			, p.UPC
			, p.QtyOnHand
			, p.DefaultSortRank
			<cfif variables.indexedViewName is "dn_Phones">
				, p.Buyurl, p.imageURL, p.RealQtyOnHand
			<cfelse>
			, null as BuyURL, null as imageURL
			</cfif>
			, '#ActivationPrice#' AS ActivationPrice
			, (SELECT TOP 1 i.ImageGuid FROM catalog.Image i WITH (NOLOCK) WHERE i.ReferenceGuid = p.ProductGuid AND i.IsPrimaryImage = 1) ImageGuid
			, ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE p.GersSku = gp.GersSku AND gp.PriceGroupCode = 'EDP'),0) DownPayment
			, ISNULL((SELECT TOP 1 gp.Price FROM catalog.GersPrice AS gp WHERE p.GersSku = gp.GersSku AND gp.PriceGroupCode = 'EMP'),0) MonthlyPayment
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'smartphone' AND pt.ProductGuid = p.ProductGuid), 0))) isSmartPhone
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'PPANORETAIL' AND pt.ProductGuid = p.ProductGuid), 0))) IsNoContractRestricted
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'PPANONEW' AND pt.ProductGuid = p.ProductGuid), 0))) IsNewActivationRestricted
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'PPANOUPGRADE' AND pt.ProductGuid = p.ProductGuid), 0))) IsUpgradeActivationRestricted
			, (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'PPANOAAL' AND pt.ProductGuid = p.ProductGuid), 0))) IsAddALineActivationRestricted
			, CASE
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'ComingSoon' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'ComingSoon'
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = '1daysale' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN '1DaySale'
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'MVM' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'Coupon'
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'WebOnlyOffer' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'WebOnlyOffer'
				WHEN (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'Closeout' AND pt.ProductGuid = p.ProductGuid), 0))) = 1 THEN 'Closeout'
				WHEN DATEDIFF( d, CONVERT(DATETIME, p.ReleaseDate), GETDATE() )	< 15 THEN 'NewRelease'
				ELSE NULL
			  END BadgeType
			, (SELECT TOP 1 pp.Value FROM catalog.Property pp WITH (NOLOCK) WHERE pp.Name = 'C9043E7D-784B-41CC-B47C-7A482FED1C34' AND pp.ProductGuid = p.ProductGuid) DeviceType
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPNEW' AND pt.ProductGuid = p.ProductGuid), 0)) IsNewPriceMap
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPUPGRADE' AND pt.ProductGuid = p.ProductGuid), 0)) IsUpgradePriceMap
			, CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE pt.Tag = 'MAPAAL' AND pt.ProductGuid = p.ProductGuid), 0)) IsAddalinePriceMap
		FROM	catalog.#variables.indexedViewName# AS p WITH (NOLOCK)
		WHERE	1=1
			<cfif variables.indexedViewName is "dn_Phones">
				<cfif channelConfig.getTmoRedirectEnabled() is false OR channelConfig.getVFDEnabled() is true>
					AND buyurl IS NULL
				</cfif>
				<cfif channelConfig.getTmoRedirectEnabled() is true AND channelConfig.getVFDEnabled() is false>
					AND (carrierid != 128 or (carrierid = 128 AND buyurl IS NOT NULL))
				</cfif>
			</cfif>			
			<cfif arguments.DisplayNoInventoryItems is false>
				and p.QtyOnHand > 0
			</cfif>	
			AND	EXISTS	(
				SELECT	1
				FROM	catalog.ProductTag AS pt WITH (NOLOCK)
				WHERE	pt.Tag			=	<cfqueryparam value="#variables.productTag#" cfsqltype="cf_sql_varchar" />
					AND	pt.ProductGuid	=	p.ProductGuid
			)
		<cfif len(trim(arguments.idList))>
			AND	p.ProductID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#trim(arguments.idList)#" />)
		<cfelse>
			<cfloop collection="#local.dynamicTags#" item="local.iFilterGroupId">
				AND (
					1 = 0
					<cfloop from="1" to="#arrayLen(local.dynamicTags[local.iFilterGroupId])#" index="local.iDynamicTag">
						OR EXISTS (
							SELECT	1
							FROM (
								<cfset local.sql = local.dynamicTags[local.iFilterGroupId][local.iDynamicTag] />
								#preserveSingleQuotes(local.sql)#
							) AS 	prod
							WHERE	prod.ProductGuid = p.ProductGuid
						)
					</cfloop>
				)
			</cfloop>
			
			<cfif arguments.ActivationPrice eq 'nocontract'>
				AND (CONVERT(bit, ISNULL((SELECT 1 FROM catalog.ProductTag pt WITH (NOLOCK) WHERE Tag = 'PPANORETAIL' AND pt.ProductGuid = p.ProductGuid), 0))) = 0
			</cfif>
		</cfif>
		AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.carrier.getActiveCarrierIds()#" list="true" /> )

		<cfif !arguments.AllowHidden>
			AND p.productGuid NOT IN (SELECT pt.ProductGuid FROM catalog.ProductTag AS pt WITH (NOLOCK) WHERE pt.Tag = 'hide' OR pt.Tag = 'autohide')
		</cfif>
		<cfif !arguments.DisplayZeroPricedItems>
			AND p.price_retail <> '0'
		</cfif>
		<cfswitch expression="#arguments.Sort#">
			<cfcase value="popular">
				ORDER BY p.defaultSortRank, price_#local.planType# DESC
			</cfcase>
			<cfcase value="PriceAsc,PriceDesc">
				ORDER BY price_#local.planType# <cfif arguments.Sort eq 'PriceAsc'>ASC<cfelse>DESC</cfif>
			</cfcase>
			<cfcase value="NameAsc,NameDesc">
				ORDER BY p.detailTitle <cfif arguments.Sort eq 'NameAsc'>ASC<cfelse>DESC</cfif>
			</cfcase>
			<cfcase value="BrandAsc,BrandDesc">
				ORDER BY p.manufacturerName <cfif arguments.Sort eq 'BrandAsc'>ASC<cfelse>DESC</cfif>
			</cfcase>
			<cfdefaultcase>
				ORDER BY p.defaultSortRank, price_#local.planType# DESC
			</cfdefaultcase>
		</cfswitch>
		
	</cfquery>

		<cfif channelConfig.getCarrierTwoYearRemoval() IS NOT "">
			<!---Get ID's and dates---->
			<cfset local.carrierExcludeIDs = channelConfig.getCarrierTwoYearRemoval()>
		
			<!---Get all the ID's we need up update---->
			<cfquery name="local.qProducts2YearExclude" dbtype="query">
				SELECT DeviceGuid
				FROM [local].qProductsByFilter
				WHERE  carrierid IN (#local.carrierExcludeIDs#)	AND (ISSMARTPHONE = 1 OR (FinancedMonthlyPrice12 > 0.00
				OR FinancedMonthlyPrice18 > 0.00
				OR FinancedMonthlyPrice24 > 0.00))
			</cfquery>
			
			<cfset local.lProducts2Exclude = ValueList(local.qProducts2YearExclude.DeviceGuid)>
	
			<cfloop query="local.qProductsByFilter">		
				<cfif ListFind(local.lProducts2Exclude,local.qProductsByFilter["DeviceGuid"][local.qProductsByFilter.currentRow])>
					<cfset local.qProductsByFilter["price_new"][local.qProductsByFilter.currentRow] = javaCast('double', 9999)>
					<cfset local.qProductsByFilter["NewPriceAfterRebate"][local.qProductsByFilter.currentRow] = javaCast('double', 9999)>
				</cfif>			
			</cfloop>	

		
	</cfif>

	<cfreturn local.qProductsByFilter />
</cffunction>


<cffunction name="getAll" access="public" output="false" returntype="query"> <!--- TRV: used only to populate search indexes --->
	<cfargument name="bActiveOnly" type="boolean" default="false">
	<cfargument name="bHasAccessories" type="boolean" default="false">
	<cfargument name="bSortBy" type="any" default="">
	<cfargument name="DisplayNoInventoryItems" type="boolean" required="false" default="#application.wirebox.getInstance("ChannelConfig").getDisplayNoInventoryItems()#">

	<cfset var local = {} />
	
	<cfquery name="local.qGetAll" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	
			p.DeviceGuid
			, p.ProductGuid
			, p.phoneID
			, p.product_id
			, p.ProductID
			, p.GersSku
			, p.pageTitle
			, p.summaryTitle
			, p.detailTitle
			, p.CarrierId
			, p.carrierName
			, p.manufacturerGuid
			, p.manufacturerName
			, p.IsAvailableInWarehouse
			, p.IsAvailableOnline
			, p.bFreeAccessory
			, p.summaryDescription
			, p.detailDescription
			, p.MetaKeywords
			, p.MetaDescription
			, p.ReleaseDate
			, p.prepaid
			, p.typeID
			, p.price_retail
			, p.price_new
			, p.price_upgrade
			, p.price_addaline
			, p.price_nocontract
			, p.UPC
			, p.QtyOnHand
			, p.DefaultSortRank
		FROM catalog.#variables.indexedViewName# p
		<cfif arguments.bActiveOnly>
			INNER JOIN catalog.Product prod WITH (NOLOCK)
				ON p.ProductGuid = prod.ProductGuid
				AND prod.Active = 1
		</cfif>
		WHERE 1=1
			<cfif arguments.DisplayNoInventoryItems is false>
				and p.QtyOnHand > 0
			</cfif>	
			AND	EXISTS (
				SELECT 1
				FROM catalog.ProductTag pt WITH (NOLOCK)
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
					AND	pt.ProductGuid = p.ProductGuid
			)
		<cfif arguments.bHasAccessories>
			AND EXISTS (
				SELECT 1 
				FROM catalog.AccessoryForDevice afd 
				WHERE afd.DeviceGuid = p.ProductGuid
			)
		</cfif>
		<!--- TRV: return only data for "enabled" carriers --->
		AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
		ORDER BY 
		<cfif Len(arguments.bSortBy)>
			#arguments.bSortBy#
		<cfelse>
			CarrierName, DetailTitle
		</cfif>
	</cfquery>
	<cfreturn local.qGetAll>
</cffunction>

<!---<cffunction name="getSearchable" access="public" output="false" returntype="query"> <!--- TRV: used only to populate search indexes --->
	<cfargument name="bActiveOnly" type="boolean" default="false">
	<cfargument name="bHasAccessories" type="boolean" default="false">
	<cfargument name="bSortBy" type="any" default="">
	
	<cfset var local = {} />
	
	<cfquery name="local.qGetAll" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	
			p.DeviceGuid
			, p.ProductGuid
			, p.phoneID
			, p.product_id
			, p.ProductID
			, p.GersSku
			, p.pageTitle
			, p.summaryTitle
			, p.detailTitle
			, p.CarrierId
			, p.carrierName
			, p.manufacturerGuid
			, p.manufacturerName
			, p.IsAvailableInWarehouse
			, p.IsAvailableOnline
			, p.bFreeAccessory
			, p.summaryDescription
			, p.detailDescription
			, p.MetaKeywords
			, p.MetaDescription
			, p.ReleaseDate
			, p.prepaid
			, p.typeID
			, p.price_retail
			, p.price_new
			, p.price_upgrade
			, p.price_addaline
			, p.price_nocontract
			, p.UPC
			, p.QtyOnHand
			, p.DefaultSortRank
		FROM catalog.#variables.indexedViewName# p
		<cfif arguments.bActiveOnly>
			INNER JOIN catalog.Product prod WITH (NOLOCK)
				ON p.ProductGuid = prod.ProductGuid
				AND prod.Active = 1
			INNER JOIN catalog.Inventory i ON i.ProductId = prod.ProductId AND i.AvailableQty > 0
		</cfif>
		WHERE 1=1
			AND	EXISTS (
				SELECT 1
				FROM catalog.ProductTag pt WITH (NOLOCK)
				WHERE
					pt.Tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productTag#">
					AND	pt.ProductGuid = p.ProductGuid
			)
		<cfif arguments.bHasAccessories>
			AND EXISTS (
				SELECT 1 
				FROM catalog.AccessoryForDevice afd 
				WHERE afd.DeviceGuid = p.ProductGuid
			)
		</cfif>
		<!--- TRV: return only data for "enabled" carriers --->
		AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
		ORDER BY 
		<cfif Len(arguments.bSortBy)>
			#arguments.bSortBy#
		<cfelse>
			CarrierName, DetailTitle
		</cfif>
	</cfquery>
	<cfreturn local.qGetAll>
</cffunction>--->


<cffunction name="getFeatures" access="public" returntype="any" output="false">
	<cfargument name="productID" required="true" type="string" />

	<cfset var local = structNew() />
	<cfset local.getFeatures = queryNew('undefined') />

	<cfif isNumeric(trim(arguments.productId))>
		<cfset local.getFeatures = application.model.propertyManager.getPropertiesByProductId(getDeviceGuidByProductID(trim(arguments.productID)), 'features') />
	</cfif>

	<cfreturn local.getFeatures />
</cffunction>


<cffunction name="getSpecs" access="public" returntype="query" output="false">
	<cfargument name="productID" type="any" required="true" />

	<cfset var local = structNew() />

	<cfif isNumeric(trim(arguments.productId))>
		<cfset local.getSpecs = application.model.propertyManager.getPropertiesByProductId(getDeviceGuidByProductID(arguments.productID), 'specifications') />
	<cfelse>
		<cfset local.getSpecs = queryNew('undefined') />
	</cfif>

	<cfreturn local.getSpecs />
</cffunction>

<cffunction name="getCompareData" returntype="any">
	<cfargument name="ProductID" required="true"> <!--- should support a comma-delimited list of ids for the compare page --->
	<cfset var local = structNew()>

	<cfset local.getCompareData = application.model.PropertyManager.getComparePropertiesByProductId(arguments.ProductID)>

	<cfreturn local.getCompareData>
</cffunction>

<cffunction name="getTypeIdByProductID" returntype="numeric">
	<cfargument name="ProductID" type="numeric" required="true">
	<cfset var local = structNew()>
	<cfset local.typeID = 1>

	<cfquery name="local.qProductType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			typeID
		FROM
			catalog.#variables.indexedViewName#
		WHERE
			ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductID#">
	</cfquery>
	<cfif local.qProductType.recordCount>
		<cfset local.typeID = local.qProductType.typeID>
	</cfif>

	<cfreturn local.typeID>
</cffunction>

<!--- TODO: remove this later - just an interface method referenced by the controller --->
<cffunction name="getTypeIdByPhoneID" returntype="numeric">
	<cfargument name="PhoneID" type="numeric" required="true">
	<cfreturn getTypeIdByProductID(ProductId=arguments.PhoneId)>
</cffunction>


<cffunction name="getProductClassByProductID" returntype="string">
	<cfargument name="ProductID" type="numeric" required="true">
	<cfset var local = structNew()>
	<cfset local.productClass = "phone">

	<cfquery name="local.qProductType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT DISTINCT
			pt.Tag
		FROM
			catalog.ProductTag pt
			INNER JOIN catalog.Product p
				on pt.ProductGuid = p.ProductGuid
		WHERE
			p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductID#">
	</cfquery>
	<cfif listFindNoCase(valueList(local.qProductType.Tag),"datadevice")>
		<cfset local.productClass = "DataCardAndNetbook">
	<cfelseif listFindNoCase(valueList(local.qProductType.Tag),"prepaid")>
		<cfset local.productClass = "PrePaid">
	<cfelseif listFindNoCase(valueList(local.qProductType.Tag),"tablet")>
		<cfset local.productClass = "Tablet">	
	</cfif>

	<cfreturn local.productClass>
</cffunction>

<cffunction name="getProductClassByPhoneID" returntype="string">
	<cfargument name="PhoneID" type="numeric" required="true">
	<cfreturn getProductClassByProductID(ProductId=arguments.PhoneId)>
</cffunction>

<cffunction name="getCarrierIDbyProductID" access="public" returntype="numeric" output="false">
	<cfargument name="productID" type="string" required="false" default="0" />

	<cfset var local = structNew() />
	<cfset local.carrierID = 0 />

	<cfif not isNumeric(trim(arguments.productId))>
		<cfset arguments.productId = 0 />
	<cfelse>
		<cfset arguments.productId = trim(arguments.productId) />
	</cfif>

	<cfquery name="local.qProductCarrierID" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	c.carrierId
		FROM	catalog.#variables.indexedViewName# AS c WITH (NOLOCK)
		WHERE	c.productID	=	<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfif local.qProductCarrierID.recordCount>
		<cfset local.carrierID = local.qProductCarrierID.carrierId />
	</cfif>

	<cfreturn local.carrierID />
</cffunction>

<cffunction name="getCarrierGUIDbyCarrierID" returntype="string">
	<cfargument name="CarrierID" type="numeric" required="true">
	<cfset var local = structNew()>
	<cfset local.carrierGUID = "">

	<cfquery name="local.qProductCarrierID" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			CompanyGUID
		FROM
			catalog.company
		WHERE
			carrierId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CarrierID#">
	</cfquery>

	<cfif local.qProductCarrierID.recordCount>
		<cfset local.carrierGUID = local.qProductCarrierID.CompanyGUID>
	</cfif>
	<cfreturn local.carrierGUID>
</cffunction>

<!--- TODO: remove this later - just an interface method referenced by the controller --->
<cffunction name="getCarrierIDbyPhoneID" returntype="string">
	<cfargument name="PhoneID" type="numeric" required="true">
	<cfreturn getCarrierIDbyProductID(ProductId=arguments.PhoneId)>
</cffunction>

<cffunction name="getFreeAccessories" access="public" returntype="query" output="false">
	<cfargument name="productID" type="string" required="true" />

	<cfset var local = structNew() />

	<cfset local.idList = '0' />

	<cfif len(trim(arguments.productID))>
		<cfset local.productGuid = getDeviceGuidByProductID(arguments.productID) />

		<cftry>
			<cfquery name="local.qFreeAccessories" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		p.productId
				FROM		catalog.accessory AS a WITH (NOLOCK)
				INNER JOIN	catalog.productGuid AS pg WITH (NOLOCK) ON a.AccessoryGuid = pg.ProductGuid
				INNER JOIN	catalog.product AS p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid
				INNER JOIN	catalog.deviceFreeAccessory AS dfa WITH (NOLOCK) ON a.AccessoryGuid = dfa.ProductGuid
						AND	GETDATE() >= dfa.StartDate
						AND GETDATE() <= dfa.EndDate
				WHERE		dfa.DeviceGuid	=	<cfqueryparam value="#local.productGuid#" cfsqltype="cf_sql_varchar" />
			</cfquery>

			<cfif local.qFreeAccessories.recordCount>
				<cfset local.idList = valueList(local.qFreeAccessories.productId) />
			</cfif>

			<cfset local.qFreeAccessories = application.model.accessory.getByFilter(idList = local.idList) />

			<cfcatch type="any">
				<cfset local.qFreeAccessories = queryNew('undefined') />
			</cfcatch>
		</cftry>
	<cfelse>
		<cfset local.qFreeAccessories = queryNew('undefined') />
	</cfif>

	<cfreturn local.qFreeAccessories />
</cffunction>

<cffunction name="getFeaturedAccessories" access="public" returntype="query" output="false">
	<cfargument name="productID" type="string" required="true" />

	<cfset var local = structNew() />

	<cfset local.idList = '0' />

	<cfif len(trim(arguments.productID))>
		
		<cfset local.productGuid = getDeviceGuidByProductID(arguments.productID) />

		<cftry>
			<cfquery name="local.qFeaturedAccessories" datasource="#application.dsn.wirelessAdvocates#">
				SELECT		p.productId
				FROM		catalog.accessory AS a WITH (NOLOCK)
				INNER JOIN	catalog.productGuid AS pg WITH (NOLOCK) ON a.AccessoryGuid = pg.ProductGuid
				INNER JOIN	catalog.product AS p WITH (NOLOCK) ON pg.ProductGuid = p.ProductGuid
				INNER JOIN	catalog.featuredAccessoryForDevice AS dfa WITH (NOLOCK) ON a.accessoryguid = dfa.AccessoryGuid
				WHERE		dfa.DeviceGuid	=	<cfqueryparam value="#local.productGuid#" cfsqltype="cf_sql_varchar" />
			</cfquery>		
					
			<cfif local.qFeaturedAccessories.recordCount>
				<cfset local.idList = valueList(local.qFeaturedAccessories.productId) />
			</cfif>

			<cfset local.qFeaturedAccessories = application.model.accessory.getByFilter(idList = local.idList) />

			<cfcatch type="any">
				<cfset local.qFeaturedAccessories = queryNew('undefined') />
			</cfcatch>
		</cftry>
	<cfelse>
	
		<cfset local.qFeaturedAccessories = queryNew('undefined') />
	</cfif>

	<cfreturn local.qFeaturedAccessories />
</cffunction>
<cffunction name="getPriceByProductIDAndMode" access="public" output="false" returntype="numeric">
	<cfargument name="ProductID" type="numeric" required="true">
	<cfargument name="mode" type="string" required="true">
	<cfset var local = structNew()>
	<cfset local.price = 0>
	<cfset local.priceColumnName = '' />

	<cfscript>
		switch(arguments.mode)
		{
			case 'new':
				local.priceColumnName = 'price_new';
				break;
			case 'upgrade':
				local.priceColumnName = 'price_upgrade';
				break;
			case 'addaline':
				local.priceColumnName = 'price_addaline';
				break;
			case 'retail':
				local.priceColumnName = 'price_retail';
				break;
			case 'nocontract':
				local.priceColumnName = 'price_nocontract';
				break;
			case 'financed':
				local.priceColumnName = 'FinancedFullRetailPrice';
				break;	
			default:
				throw('Invalid mode for price - #arguments.mode#');
				break;					
		}
	</cfscript>
	
	<cfquery name="local.qGetProductPrice" datasource="#application.dsn.wirelessAdvocates#">
		SELECT #local.priceColumnName# as price
		FROM catalog.#variables.indexedViewName#
		WHERE ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductID#">
	</cfquery>

	<cfif local.qGetProductPrice.recordCount>
		<cfset local.price = local.qGetProductPrice.price>
	</cfif>

	<cfreturn local.price>
</cffunction>

<!--- TODO: remove this later - just an interface method referenced by the controller --->
<cffunction name="getPriceByPhoneIdAndMode" access="public" output="false" returntype="numeric">
	<cfargument name="PhoneId" type="numeric" required="true">
	<cfargument name="mode" type="string" required="true">
	<cfreturn getPriceByProductIDAndMode(ProductId=arguments.PhoneId,mode=arguments.mode)>
</cffunction>

<cffunction name="getDeviceGuidByProductID" access="public" returntype="string" output="false">
	<cfargument name="productID" type="numeric" required="true" />

	<cfset var local = structNew() />
	<cfset local.return = 0 />

	<cfquery name="local.qDeviceGuid" datasource="#application.dsn.wirelessAdvocates#">
		SELECT	d.ProductGuid
		FROM	catalog.Product AS d WITH (NOLOCK)
		WHERE	d.ProductID	=	<cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfif local.qDeviceGuid.recordCount>
		<cfset local.return = local.qDeviceGuid.ProductGuid />
	</cfif>

	<cfreturn local.return />
</cffunction>

<cffunction name="getDeviceGuidByPhoneID" returntype="string">
	<cfargument name="PhoneID" type="numeric" required="true">
	<cfreturn getDeviceGuidByProductID(ProductId=arguments.PhoneId)>
</cffunction>

<cffunction name="getProductIdsByPlanId" access="public" output="false" returntype="string">
	<cfargument name="PlanId" type="numeric" required="true">
	<cfset var local = arguments>
	<cfset local.return = "">
	<cfquery name="local.qGetProductIdsByPlanId" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			pd.ProductId
		FROM
			catalog.RateplanDevice rd
			INNER JOIN catalog.Product pd
				ON rd.DeviceGuid = pd.ProductGuid
			INNER JOIN catalog.Product pr
				ON rd.RateplanGuid = pr.ProductGuid
		WHERE
			pr.ProductId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PlanId#">
	</cfquery>

	<cfif local.qGetProductIdsByPlanId.recordCount>
		<cfset local.return = valueList(local.qGetProductIdsByPlanId.ProductId)>
	</cfif>
	<cfreturn local.return>
</cffunction>

<cffunction name="getProductTypeIDByProductID" returntype="string">
	<cfargument name="product_id" type="numeric" required="true">
	<cfset var local = structNew()>

	<cfquery name="local.qProductTypeID" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			pt.ProductType
		FROM
			catalog.Product p
			INNER JOIN catalog.ProductGuid pg
				ON p.ProductGuid = pg.ProductGuid
			INNER JOIN catalog.ProductType pt
				ON pg.ProductTypeId = pt.ProductTypeId
		WHERE
			p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
	</cfquery>
	<cfreturn local.qProductTypeID.ProductType>
</cffunction>

<cffunction name="getProductGuidByProductId" access="public" output="false" returntype="string">
	<cfargument name="productId" type="numeric" required="true">
	<cfset var local = structNew()>
	<cfset local.return = 0>

	<cfquery name="local.qGetProductGuid" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			ProductGuid
		FROM
			catalog.Product
		WHERE
			ProductId = <cfqueryparam cfsqltype="cf_Sql_integer" value="#arguments.productId#">
	</cfquery>
	<cfif local.qGetProductGuid.recordCount and len(trim(local.qGetProductGuid.ProductGuid))>
		<cfset local.return = local.qGetProductGuid.ProductGuid>
	</cfif>

	<cfreturn local.return>
</cffunction>

<cffunction name="getProductIdByProductGuid" access="public" output="false" returntype="numeric">
	<cfargument name="productGuid" type="string" required="true">
	<cfset var local = structNew()>
	<cfset local.return = 0>

	<cfquery name="local.qGetProductId" datasource="#application.dsn.wirelessAdvocates#">
		SELECT
			ProductId
		FROM
			catalog.Product
		WHERE
			ProductGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productGuid#">
	</cfquery>
	<cfif local.qGetProductId.recordCount and len(trim(local.qGetProductId.ProductId))>
		<cfset local.return = local.qGetProductId.ProductId>
	</cfif>

	<cfreturn local.return>
</cffunction>

<cffunction name="getProductTitle" access="public" returntype="query" output="false">
	<cfargument name="productId" required="true" type="numeric" />

	<cfset var getProductTitleReturn = '' />
	<cfset var qry_getProductTitle = '' />

	<cfquery name="qry_getProductTitle" datasource="#application.dsn.wirelessAdvocates#">
		SELECT		v.ProductGuid, pm.[Value] AS Title
		FROM		dbo.vGetAllProducts AS v WITH (NOLOCK)
		INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.ProductGuid = v.ProductGuid
		INNER JOIN	catalog.Property AS pm WITH (NOLOCK) ON pm.ProductGuid = p.ProductGuid AND pm.[Name] = 'Title'
		WHERE		p.ProductId	=	<cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfset getProductTitleReturn = qry_getProductTitle />

	<cfreturn getProductTitleReturn />
</cffunction>

<cffunction name="getEarlyTerminationFee" access="public" returntype="struct" output="false">
	<cfargument name="productId" required="true" type="numeric" />

	<cfset var getEarlyTerminationFeeReturn = structNew() />
	<cfset var qry_getEarlyTerminationFee = '' />

	<cfquery name="qry_getEarlyTerminationFee" datasource="#application.dsn.wirelessAdvocates#">
		SELECT		p.ProductId, pp.[Name], pp.[Value]
		FROM		catalog.Product AS p WITH (NOLOCK)
		INNER JOIN	catalog.Property AS pp WITH (NOLOCK) ON pp.ProductGuid = p.ProductGuid
		WHERE		pp.Name 	IN	('ETFDeviceCategory', 'ETFContractTerm', 'ETFTerminationFee', 'ETFDecliningAmount')
				AND	p.ProductId	=	<cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cfloop query="qry_getEarlyTerminationFee">
		<cfswitch expression="#qry_getEarlyTerminationFee.Name#">
			<cfcase value="ETFContractTerm">
				<cfset getEarlyTerminationFeeReturn.ETFContractTerm = qry_getEarlyTerminationFee.Value[qry_getEarlyTerminationFee.currentRow] />
			</cfcase>

			<cfcase value="ETFDecliningAmount">
				<cfset getEarlyTerminationFeeReturn.ETFDecliningAmount = qry_getEarlyTerminationFee.Value[qry_getEarlyTerminationFee.currentRow] />
			</cfcase>

			<cfcase value="ETFDeviceCategory">
				<cfset getEarlyTerminationFeeReturn.ETFDeviceCategory = qry_getEarlyTerminationFee.Value[qry_getEarlyTerminationFee.currentRow] />
			</cfcase>

			<cfcase value="ETFTerminationFee">
				<cfset getEarlyTerminationFeeReturn.ETFTerminationFee = qry_getEarlyTerminationFee.Value[qry_getEarlyTerminationFee.currentRow] />
			</cfcase>
		</cfswitch>
	</cfloop>

	<cfreturn getEarlyTerminationFeeReturn />
</cffunction>

<cffunction name="getCarrierDeviceType" access="public" returntype="string" output="false">
	<cfargument name="ProductId" required="true" type="numeric" />
	<cfargument name="CarrierId" required="true" type="numeric" />

	<cfset var qDeviceType = '' />
	<cfset var techonologyType = '' />

	<cfquery name="qDeviceType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT TOP 1
			dp.ProductId
			, c.CarrierId
			, p.Value TechnologyType
		FROM catalog.dn_AllProducts d 
		INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
		INNER JOIN catalog.Property p ON p.ProductGuid = d.DeviceGuid AND p.Name = 'TECHNOLOGY_TYPE'
		INNER JOIN catalog.Company c ON c.CompanyGuid = d.CarrierGuid
		WHERE 
			dp.Productid = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" /> 
			AND c.CarrierId = <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" /> 
	</cfquery>
	
	<cfscript>
		//4GE, VRA, CDM, and ""
		
		if ( qDeviceType.RecordCount )
		{
			switch (qDeviceType.TechnologyType)
			{
				case '4G':
					techonologyType = 'Item4GE';
					break;
				case '3G':
					techonologyType = 'CDM';
					break;				
				default:
					techonologyType = '';
					break;
			}
		}
	</cfscript>

	<cfreturn techonologyType />
</cffunction>


<cffunction name="getCarrierTechnologyType" access="public" returntype="string" output="false">
	<cfargument name="ProductId" required="true" type="numeric" />
	<cfargument name="CarrierId" required="true" type="numeric" />

	<cfset var qDeviceType = '' />
	<cfset var techonologyType = '' />

	<cfquery name="qDeviceType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT TOP 1
			dp.ProductId
			, c.CarrierId
			, p.Value TechnologyType
		FROM catalog.Device d 
		INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
		INNER JOIN catalog.Property p ON p.ProductGuid = d.DeviceGuid AND p.Name = 'PartType'
		INNER JOIN catalog.Company c ON c.CompanyGuid = d.CarrierGuid
		WHERE 
			dp.Productid = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" /> 
			AND c.CarrierId = <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" /> 
	</cfquery>
	
	<cfscript>
		if ( qDeviceType.RecordCount )
		{
			switch (qDeviceType.TechnologyType)
			{
				case 'GSM':
					techonologyType = 'GSM';
					break;					
				default:
					techonologyType = 'UMTS';
					break;
			}
		}
	</cfscript>

	<cfreturn techonologyType />
</cffunction>

<cffunction name="getDeviceServiceType" access="public" returntype="string" output="false">
	<cfargument name="ProductId" required="true" type="numeric" />
	<cfargument name="CarrierId" required="true" type="numeric" />

	<cfscript>
		var qServiceType = '';
		var serviceType = '';
		var propertyName = 'C9043E7D-784B-41CC-B47C-7A482FED1C34';
	</cfscript>

	<!---<cfquery name="qServiceType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT TOP 1
			dp.ProductId
			, c.CarrierId
			, CASE 
				WHEN p.Value NOT IN ('Data only', 'Basic') THEN 'SmartPhone'
				WHEN p.Value = 'Basic' THEN 'FeaturePhone'
				WHEN p.Value = 'Data only' THEN 'MobileBroadband'
				ELSE ''
			END ServiceType
		FROM catalog.Device d 
		INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
		INNER JOIN catalog.Property p ON p.ProductGuid = d.DeviceGuid AND p.Name = <cfqueryparam value="#propertyName#" cfsqltype="cf_sql_varchar" /> 
		INNER JOIN catalog.Company c ON c.CompanyGuid = d.CarrierGuid
		WHERE
			dp.Productid = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" /> 
			AND c.CarrierId = <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" /> 
	</cfquery>--->
	
	<cfquery name="qServiceType" datasource="#application.dsn.wirelessAdvocates#">
		SELECT TOP 1
		dp.ProductId
		, c.CarrierId
		, CASE 
		       WHEN d.DeviceGuid IN (SELECT ProductGuid FROM catalog.ProductGuid WHERE ProductTypeId = '6') THEN 'Tablet'
		       WHEN p.Value NOT IN ('Data only', 'Basic') AND d.DeviceGuid NOT IN (SELECT ProductGuid FROM catalog.ProductGuid WHERE ProductTypeId = '6') THEN 'SmartPhone'
		       WHEN p.Value = 'Basic' THEN 'FeaturePhone'
		       WHEN p.Value = 'Data only' THEN 'MobileBroadband'
		       ELSE ''
		END ServiceType
		FROM catalog.dn_AllProducts d 
		INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
		INNER JOIN catalog.Property p ON p.ProductGuid = d.DeviceGuid AND p.Name = <cfqueryparam value="#propertyName#" cfsqltype="cf_sql_varchar" /> 
		INNER JOIN catalog.Company c ON c.CompanyGuid = d.CarrierGuid
		WHERE
		dp.Productid = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
		AND c.CarrierId = <cfqueryparam value="#arguments.CarrierId#" cfsqltype="cf_sql_integer" />
	</cfquery>
	
	<cfif qServiceType.RecordCount>
		<cfset serviceType = qServiceType.ServiceType />
	</cfif>

	<cfreturn serviceType />
</cffunction>


<cffunction name="getAvailableInventoryCount" access="public" returntype="string" output="false">
	<cfargument name="ProductId" required="true" type="numeric" />

	<cfset qIventory = '' />
	<cfset quantity = 0 />

	<cfquery name="qIventory" datasource="#application.dsn.wirelessAdvocates#">
		SELECT AvailableQty
		FROM Catalog.Inventory
		WHERE Productid = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" /> 
	</cfquery>
	
	<cfif qIventory.RecordCount>
		<cfset quantity = qIventory.AvailableQty />
	</cfif>

	<cfreturn quantity />
</cffunction>
