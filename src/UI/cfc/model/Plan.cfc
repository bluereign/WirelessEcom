<cfcomponent output="false" displayname="Plan">

	<cffunction name="init" returntype="Plan">
		<cfset variables.PlanFilter = application.wirebox.getInstance("PlanFilter") />
		<cfreturn this />
	</cffunction>

	<cffunction name="getDetail" returntype="query">
		<cfargument name="planID" type="string" default="">
		<cfset var local = structNew()>
		<cfset local.PlanInfo = structNew()>

		<cfquery name="local.PlanInfo" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.*
			FROM
				catalog.dn_Plans p
			WHERE
				1=1
			AND	p.planID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.planID#">
			<!--- TRV: return only data for "enabled" carriers --->
			AND	p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
		</cfquery>


		<cfreturn local.PlanInfo />
	</cffunction>
	
	<cffunction name="getDetailByBillCode" returntype="query">
		<cfargument name="carrierBillcode" type="string" default="">
		<cfset var local = structNew()>
		<cfset local.PlanInfo = structNew()>

		<cfquery name="local.PlanInfo" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.*
			FROM
				catalog.rateplan p
			WHERE
					p.carrierBillcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.carrierBillcode#">
		</cfquery>


		<cfreturn local.PlanInfo />
	</cffunction>

	<cffunction name="getCompare" access="public" returntype="query" output="false">
		<cfargument name="planIDs" required="false" type="string" default="" />

		<cfset var local = structNew() />
		<cfset local.planInfo = structNew() />

		<cfif len(trim(arguments.planIDs))>
			<cfquery name="local.planCompare" datasource="#application.dsn.wirelessAdvocates#">
				SELECT	p.*
				FROM	catalog.dn_Plans AS p WITH (NOLOCK)
				WHERE	1			=	1
					AND	p.planID	IN	(<cfqueryparam value="#arguments.planIDs#" cfsqltype="cf_sql_integer" list="true" />)
					AND	p.carrierID	IN	(<cfqueryparam value="#application.model.carrier.getActiveCarrierIds()#" list="true" cfsqltype="cf_sql_integer" />)
			</cfquery>
		<cfelse>
			<cfset local.planCompare = queryNew('undefined') />
		</cfif>

		<cfreturn local.planCompare />
	</cffunction>

	<cffunction name="getByFilter" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="sort" type="string" default="carrier" />
		<cfargument name="idList" type="string" default="" />

		<cfset var local = structNew() />

		<cfset local.zipcode = '' />

		<cfif application.model.cartHelper.zipCodeEntered()>
			<cfset local.zipcode = session.cart.getZipcode() />
			<cfset local.zipcode = trim(listFirst(local.zipcode, '-')) />
		</cfif>

		<cfset local.planTypes = '' />

		<cfif not len(arguments.idList)>
			<cfset local.dynamicTags = structNew() />

			<cfloop list="#variables.PlanFilter.getUserSelectedFilterValuesByFieldName(fieldName = 'filterOptions')#" index="local.iFilterOption">
				<cfquery name="local.qFilterOption" datasource="#application.dsn.wirelessAdvocates#">
					SELECT		fo.FilterGroupId, fo.DynamicTag
					FROM		catalog.FilterOption AS fo WITH (NOLOCK)
					INNER JOIN	catalog.FilterGroup AS fg WITH (NOLOCK) ON fg.FilterGroupId = fo.FilterGroupId
							AND	fg.Active			=	<cfqueryparam value="1" cfsqltype="cf_sql_integer" />
					WHERE		fo.FilterOptionId	=	<cfqueryparam value="#local.iFilterOption#" cfsqltype="cf_sql_integer" />
							AND	fo.Active			=	<cfqueryparam value="1" cfsqltype="cf_sql_integer" />
				</cfquery>

				<cfif local.qFilterOption.recordCount and len(trim(local.qFilterOption.dynamicTag))>
					<cfif not structKeyExists(local.dynamicTags, local.qFilterOption.filterGroupId[local.qFilterOption.currentRow])>
						<cfset local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]] = arrayNew(1) />
					</cfif>

					<cfset arrayAppend(local.dynamicTags[local.qFilterOption.filterGroupId[local.qFilterOption.currentRow]], local.qFilterOption.dynamicTag) />
				</cfif>
			</cfloop>
		</cfif>

		<cfquery name="local.qPlansByFilter" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	
				p.RateplanGuid
				, p.ProductGuid
				, p.PlanId
				, p.ProductId
				, p.GersSku
				, p.CarrierBillCode
				, p.PlanName
				, p.PlanType
				, p.IsShared
				, p.PageTitle
				, p.SummaryTitle
				, p.DetailTitle
				, p.FamilyPlan
				, p.CompanyName
				, p.CarrierName
				, p.CarrierId
				, p.CarrierGuid
				, p.CarrierLogoSmall
				, p.CarrierLogoMedium
				, p.CarrierLogoLarge
				, p.SummaryDescription
				, p.DetailDescription
        		, p.MetaKeywords
				, p.PlanPrice
				, p.MonthlyFee
				, p.IncludedLines
				, p.MaxLines
				, p.AdditionalLineFee
				, p.minutes_anytime
				, p.minutes_offpeak
				, p.minutes_mobtomob
				, p.minutes_friendsandfamily
				, p.unlimited_offpeak
				, p.unlimited_mobtomob
				, p.unlimited_friendsandfamily
				, p.unlimited_data
				, p.unlimited_textmessaging
				, p.free_longdistance
				, p.free_roaming
				, p.data_limit
				, p.DataLimitGB
				, p.additional_data_usage
				, IsNull( (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.ProductGuid = p.ProductGuid AND pp.Name = 'PLAID_DEVICE_CAP_INDICATOR'), 'N') HasPlanDeviceCap
			FROM	catalog.dn_Plans AS p WITH (NOLOCK)
			WHERE	1	=	1

			<cfif len(trim(local.zipcode)) and not len(trim(arguments.idList))>
				AND EXISTS	(
						SELECT			1
						FROM			catalog.dn_Plans AS p2 WITH (NOLOCK)
						INNER LOOP JOIN	catalog.RateplanMarket AS rm WITH (NOLOCK) ON p2.RateplanGuid = rm.RateplanGuid
						INNER LOOP JOIN catalog.ZipCodeMarket AS zm WITH (NOLOCK) ON rm.MarketGuid = zm.MarketGuid
						WHERE			zm.ZipCode	=	<cfqueryparam value="#local.zipcode#" cfsqltype="cf_sql_varchar" />
									AND	p2.CarrierBillCode = p.CarrierBillCode
					)
			</cfif>

			<cfif len(arguments.idList)>
				AND (
						1 = 0
						<cfloop list="#arguments.idList#" index="local.thisID">
							<cfif len(trim(local.thisId))>
								OR (
									p.planId	=	<cfqueryparam value="#local.thisId#" cfsqltype="cf_sql_integer" />
								)
							</cfif>
						</cfloop>
					)
			<cfelse>
				<cfloop collection="#local.dynamicTags#" item="local.iFilterGroupId">
					AND (
						1 = 0
						<cfloop from="1" to="#arrayLen(local.dynamicTags[local.iFilterGroupId])#" index="local.iDynamicTag">
							OR EXISTS (
								SELECT	1
								FROM	(
										<cfset local.sql = local.dynamicTags[local.iFilterGroupId][local.iDynamicTag] />
										#preserveSingleQuotes(local.sql)#
								) AS prod
								WHERE	prod.ProductGuid = p.ProductGuid
							)
						</cfloop>
					)
				</cfloop>
			</cfif>

			AND	p.carrierID IN ( <cfqueryparam value="#application.model.carrier.getActiveCarrierIds()#" cfsqltype="cf_sql_integer" list="true" /> )

			AND p.PlanPrice > 0

			<cfswitch expression="#arguments.sort#">
				<cfcase value="PriceAsc,PriceDesc">
					ORDER BY p.planPrice <cfif arguments.Sort eq 'PriceAsc'>ASC<cfelse>DESC</cfif>, CAST(p.minutes_anytime AS integer) ASC, CAST(p.DataLimitGB AS DECIMAL(10,5)) ASC
				</cfcase>
				<cfcase value="MinuteAsc,MinuteDesc">
					ORDER BY 
						CAST(p.minutes_anytime AS integer) <cfif arguments.Sort eq 'MinuteAsc'>ASC<cfelse>DESC</cfif>
						, p.planPrice ASC
				</cfcase>
				<cfcase value="DataAsc,DataDesc">
					ORDER BY 
						CAST(p.DataLimitGB AS DECIMAL(10,5)) <cfif arguments.Sort eq 'DataAsc'>ASC<cfelse>DESC</cfif>
						, p.planPrice ASC
				</cfcase>
				<cfdefaultcase>
					ORDER BY p.planPrice, CAST(p.minutes_anytime AS integer) ASC, CAST(p.DataLimitGB AS DECIMAL(10,5)) ASC
				</cfdefaultcase>
			</cfswitch>
		</cfquery>

		<cfreturn local.qPlansByFilter />
	</cffunction>

	<cffunction name="getAll" access="public" output="false" returntype="query"> <!--- TRV: used only to populate search indexes --->
		<cfargument name="bActiveOnly" type="boolean" default="false">
		<cfset var local = structNew()>
		<cfquery name="local.qGetAll" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.RateplanGuid
				, p.ProductGuid
				, p.PlanId
				, p.ProductId
				, p.GersSku
				, p.CarrierBillCode
				, p.PlanName
				, p.PlanType
				, p.IsShared
				, p.PageTitle
				, p.SummaryTitle
				, p.DetailTitle
				, p.FamilyPlan
				, p.CompanyName
				, p.CarrierName
				, p.CarrierId
				, p.CarrierGuid
				, p.CarrierLogoSmall
				, p.CarrierLogoMedium
				, p.CarrierLogoLarge
				, p.SummaryDescription
				, p.DetailDescription
				, p.PlanPrice
				, p.MonthlyFee
				, p.IncludedLines
				, p.MaxLines
				, p.MetaKeywords
				, p.AdditionalLineFee
				, p.minutes_anytime
				, p.minutes_offpeak
				, p.minutes_mobtomob
				, p.minutes_friendsandfamily
				, p.unlimited_offpeak
				, p.unlimited_mobtomob
				, p.unlimited_friendsandfamily
				, p.unlimited_data
				, p.unlimited_textmessaging
				, p.free_longdistance
				, p.free_roaming
				, p.data_limit
				, p.DataLimitGB
				, p.additional_data_usage
				, p.MetaKeywords
			FROM catalog.dn_Plans p
			<cfif arguments.bActiveOnly>
				INNER JOIN catalog.Product prod
					ON p.RateplanGuid = prod.ProductGuid
					AND prod.Active = 1
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			WHERE p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
			ORDER BY CarrierName, DetailTitle
		</cfquery>
		<cfreturn local.qGetAll>
	</cffunction>

	<cffunction name="getSearchable" access="public" output="false" returntype="query"> <!--- TRV: used only to populate search indexes --->
		<cfargument name="bActiveOnly" type="boolean" default="false">
		<cfset var local = structNew()>
		<cfquery name="local.qGetAll" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.RateplanGuid
				, p.ProductGuid
				, p.PlanId
				, p.ProductId
				, p.GersSku
				, p.CarrierBillCode
				, p.PlanName
				, p.PlanType
				, p.IsShared
				, p.PageTitle
				, p.SummaryTitle
				, p.DetailTitle
				, p.FamilyPlan
				, p.CompanyName
				, p.CarrierName
				, p.CarrierId
				, p.CarrierGuid
				, p.CarrierLogoSmall
				, p.CarrierLogoMedium
				, p.CarrierLogoLarge
				, p.SummaryDescription
				, p.DetailDescription
				, p.PlanPrice
				, p.MonthlyFee
				, p.IncludedLines
				, p.MaxLines
				, p.MetaKeywords
				, p.AdditionalLineFee
				, p.minutes_anytime
				, p.minutes_offpeak
				, p.minutes_mobtomob
				, p.minutes_friendsandfamily
				, p.unlimited_offpeak
				, p.unlimited_mobtomob
				, p.unlimited_friendsandfamily
				, p.unlimited_data
				, p.unlimited_textmessaging
				, p.free_longdistance
				, p.free_roaming
				, p.data_limit
				, p.DataLimitGB
				, p.additional_data_usage
				, p.MetaKeywords
			FROM catalog.dn_Plans p
			<cfif arguments.bActiveOnly>
				INNER JOIN catalog.Product prod
					ON p.RateplanGuid = prod.ProductGuid
					AND prod.Active = 1
			</cfif>
			<!--- TRV: return only data for "enabled" carriers --->
			WHERE p.carrierID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#application.model.Carrier.getActiveCarrierIds()#" list="true"> )
			ORDER BY CarrierName, DetailTitle
		</cfquery>
		<cfreturn local.qGetAll>
	</cffunction>

    <cffunction name="getPlanSpecs" returntype="struct">
		<cfargument name="planID" type="numeric" default="">
		<cfset var local = structNew()>
		<cfset local.Specs = StructNew()>

        <cfquery name="local.PlanCompare" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.*
			FROM
				dn_Plans p
			WHERE
				p.planId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.planId#">
		</cfquery>

		<!--- dump the specs into a label value pair so that it can be looped through --->
        <!--- not clean now, but will be good for the view in the future. If we ever do get these specs relational --->
        <cfset local.specsCounter = 1>

        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Any Time Minutes">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.minutes_anytime>
        <cfset local.Specs[local.specsCounter].DataType = "int">
        <cfset local.Specs[local.specsCounter].SortKey = 1>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Off Peak Minutes">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.minutes_offpeak>
        <cfset local.Specs[local.specsCounter].DataType = "int">
        <cfset local.Specs[local.specsCounter].SortKey = 3>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Mobile to Mobile Minutes">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.minutes_mobtomob>
        <cfset local.Specs[local.specsCounter].DataType = "int">
        <cfset local.Specs[local.specsCounter].SortKey = 4>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Friends & Family Minutes">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.minutes_friendsandfamily>
        <cfset local.Specs[local.specsCounter].DataType = "int">
        <cfset local.Specs[local.specsCounter].SortKey = 5>

       	<cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Unlimited Data">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.unlimited_data>
        <cfset local.Specs[local.specsCounter].DataType = "bool">
        <cfset local.Specs[local.specsCounter].SortKey = 6>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Unlimited Text Messaging">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.unlimited_textmessaging>
        <cfset local.Specs[local.specsCounter].DataType = "bool">
        <cfset local.Specs[local.specsCounter].SortKey = 7>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Free Long Distance">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.free_longdistance>
        <cfset local.Specs[local.specsCounter].DataType = "bool">
        <cfset local.Specs[local.specsCounter].SortKey = 8>

        <cfset local.specsCounter = local.specsCounter + 1>
        <cfset local.Specs[local.specsCounter] = StructNew()>
        <cfset local.Specs[local.specsCounter].Label = "Free Roaming">
        <cfset local.Specs[local.specsCounter].Value = local.PlanCompare.free_roaming>
        <cfset local.Specs[local.specsCounter].DataType = "bool">
        <cfset local.Specs[local.specsCounter].SortKey = 9>

		<cfreturn local.Specs>

    </cffunction>

	<cffunction name="getOptions" returntype="Query">
		<cfargument name="planData" type="query" required="true">
		<cfargument name="phoneId" type="numeric" default="0">
		<cfset var local = structNew()>

		<!--- get a plan ID and a zipcode --->
		<cfquery name="local.qPlansByFilter" datasource="#application.dsn.wirelessAdvocates#">
			SELECT TOP 1
				planID
			FROM
				vPlanMarkets v
			WHERE
				carrierID = <cfqueryparam value="#ARGUMENTS.planData.carrierID#" cfsqltype="cf_sql_numeric" />
			AND	planName = <cfqueryparam value="#ARGUMENTS.planData.planName#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfquery name="local.getList" datasource="#application.dsn.wirelessAdvocates#">
			select distinct
				g.ordinal,
				p.optionalfeatureid,
				p.name as optionalfeaturename,
				p.description as optionalfeaturedesc,
				p.optionalfeaturevalue as price,
				p.featuregroupcode,
				g.name as groupname
			from
				ctproduct p
				left outer join ctfeaturegroup g
					on p.featuregroupcode = g.featuregroupcode
			where
				p.producttypecode = 'OPFT'
			and	p.active = 1
			and	p.productid not in (35520,22808)
			and	p.manufacturerid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#ARGUMENTS.planData.carrierID#">
			<cfif arguments.phoneID>
				<!--- features excluded by device --->
				and p.productid not in (
					select distinct
						optionalfeatureid
					from
						ctoptionalfeatureexclusion
					where
						productid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.phoneID#">
				)
			</cfif>
			<!--- features excluded by plan --->
			and p.productid not in (
				select
					optionalfeatureid
				from
					ctoptionalfeatureexclusion
				where
					planid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#local.qPlansByFilter.planID#">
			)
			order by g.ordinal, g.name, OptionalFeatureName
		</cfquery>

		<cfreturn local.getList />
	</cffunction>

	<cffunction name="getServices" returntype="Query">
		<cfargument name="planData" type="query" required="true">
		<cfargument name="phoneId" type="numeric" default="0">
		<cfset var local = structNew()>

		<cfquery name="local.qRateplanServices" datasource="#application.dsn.wirelessAdvocates#">
			select
				s.*
			,	p.*
			from
				catalog.Rateplan r
				inner join catalog.RateplanService rs
					on r.RateplanGuid = rs.RateplanGuid
				inner join catalog.Service s
					on rs.ServiceGuid = s.ServiceGuid
				inner join catalog.Product p
					on s.ServiceGuid = p.ProductGuid
			where
				p.Active = 1
			AND	r.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.planData.RateplanGuid#">
			<!--- features by device --->
			<cfif arguments.phoneID>
				AND EXISTS (
					SELECT 1
					FROM catalog.DeviceService ds
						INNER JOIN catalog.Product pd
							on ds.DeviceGuid = pd.ProductGuid
					WHERE
						pd.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.phoneId#">
					AND	ds.ServiceGuid = s.ServiceGuid
				)
			</cfif>
		</cfquery>

		<cfreturn local.qRateplanServices />
	</cffunction>

	<cffunction name="getCarrierIDbyPlanID" returntype="numeric">
		<cfargument name="planID" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qPlanCarrierID" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				carrierID
			FROM
				catalog.dn_Plans
			WHERE
				planID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.planID#">
		</cfquery>
		<cfreturn local.qPlanCarrierID.carrierID>
	</cffunction>

	<cffunction name="getPlanTypeByProductID" returntype="string">
		<cfargument name="productId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfquery name="local.qPlanType" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				PlanType
			FROM
				catalog.dn_Plans
			WHERE
				ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#">
		</cfquery>
		<cfif local.qPlanType.recordCount and len(trim(local.qPlanType.PlanType))>
			<cfset local.return = local.qPlanType.PlanType>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getIncludedFeatures" returntype="query">
		<cfargument name="planID" type="numeric" default="0">
		<cfset var local = structNew()>
		<cfset local.planID = arguments.planID>
		<cfset local.lstFeatureIDs = 0>

		<cfquery name="local.qPlanIncludedFeatures" datasource="#application.dsn.wirelessAdvocates#">
			select
				ctf.featureid
			,	ctf.featuregroupcode
			,	ctf.featuretypecode
			,	ctf.name
			,	ctf.description
			,	ctpf.[value] as includedValue
			,	1 as display
			from
				CARTOYS_WIRELESS.dbo.CTFeature ctf
				inner join CARTOYS_WIRELESS.dbo.CTProductFeature ctpf
					on ctf.FeatureId = ctpf.FeatureId
					and ctf.Active = 1
					and ctf.Show = 1
			where
				ctpf.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.planID#">
			order by ctf.Ordinal
		</cfquery>

		<!--- TRV: this is just a semi-educated guess, but it looks like we're only interested in included features without a specific numeric CTProductFeature.value associated to them (though I could be wrong on this) --->
		<!--- so, loop through the returned results and flag any numeric value features as display=0 --->
		<cfloop query="local.qPlanIncludedFeatures">
			<cfif isNumeric(local.qPlanIncludedFeatures.includedValue[local.qPlanIncludedFeatures.currentRow])>
				<cfset querySetCell(local.qPlanIncludedFeatures,"display",0,local.qPlanIncludedFeatures.currentRow)>
			</cfif>
		</cfloop>

		<cfreturn local.qPlanIncludedFeatures>
	</cffunction>

	<cffunction name="isPlanAvailableInZipcode" access="public" output="false" returntype="boolean">
		<cfargument name="planId" type="numeric" required="true">
		<cfargument name="zipcode" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfset local.zipcode = arguments.zipcode>
		<cfif len(local.zipcode) gt 5>
			<cfset local.zipcode = left(local.zipcode,5)>
		</cfif>

		<cfquery name="local.qCheckPlanAvailableInZipcode" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.planId
			FROM
				catalog.dn_Plans p
				INNER JOIN catalog.RateplanMarket rm
					ON p.RateplanGuid = rm.RatePlanGuid
				INNER JOIN catalog.Market m
					ON rm.MarketGuid = m.MarketGuid
				INNER JOIN catalog.ZipCodeMarket zcm
					on m.MarketGuid = zcm.MarketGuid
			WHERE
				p.planId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.planId#">
			AND	zcm.ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.zipcode#">
		</cfquery>
		<cfif local.qCheckPlanAvailableInZipcode.recordCount>
			<cfset local.return = true>
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="getSpecs" returntype="any">
		<cfargument name="planID" required="true"> <!--- should support a comma-delimited list of ids for the compare page --->
		<cfset var local = structNew()>

		<cfset local.getSpecs = application.model.PropertyManager.getPropertiesByProductId(application.model.Product.getProductGuidByProductId(arguments.planID),"specifications",true)>

		<cfreturn local.getSpecs>
	</cffunction>

	<cffunction name="getPlanIdsByProductId" access="public" output="false" returntype="string">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfset var local = arguments>
		<cfset local.return = "">
		<cfquery name="local.qGetPlanIdsByProductId" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				pr.ProductId
			FROM
				catalog.RateplanDevice rd
				INNER JOIN catalog.Product pr
					ON rd.RateplanGuid = pr.ProductGuid
				INNER JOIN catalog.Product pd
					ON rd.DeviceGuid = pd.ProductGuid
			WHERE
				pd.ProductId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ProductId#">
		</cfquery>
		<cfif local.qGetPlanIdsByProductId.recordCount>
			<cfset local.return = valueList(local.qGetPlanIdsByProductId.ProductId)>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cffunction name="getPlanGersSku" access="public" output="false" returntype="string">
		<cfargument name="ProductId" type="numeric" required="true" />
		<cfargument name="LineNumber" type="numeric" required="true" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		<cfargument name="CarrierId" type="numeric" required="true" />
		<cfargument name="CartPlanIDCount" type="numeric" required="false" default="1" hint="Represents the position of this plan in the cart in relation to other plans with the same productID" />
		<cfargument name="DeviceSKU" type="string" required="true" />
		<cfargument name="ActivationType" type="string" required="true" />
		<cfargument name="ratePlanLength" type="numeric" required="false" default="24"/>
		
		
		<cfset var local = arguments>
		<cfset local.gersSku = "">
		
		<cfquery name="local.qGetPlanGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT catalog.GetRateplanGersSku(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierId#" />
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceType#" />
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceSKU#" />
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cartPlanIdCount#" />
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lineNumber#" />
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#" />
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationType#" />
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ratePlanLength#" />
				) as GersSku
		</cfquery>
		<cfif local.qGetPlanGersSku.recordCount>
			<cfset local.gersSku = local.qGetPlanGersSku.GersSku />
		</cfif>
		<cfreturn local.gersSku />
	</cffunction>

	<cffunction name="getMonthlyFee" access="public" output="false" returntype="string">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfargument name="LineNumber" type="numeric" required="true">
		<cfargument name="CarrierId" type="numeric" required="true">
		<cfargument name="CartPlanIDCount" type="numeric" required="false" default="1" hint="Represents the position of this plan in the cart in relation to other plans with the same productID">
						
		<cfset var qGetPlanMonthlyFee = "">
		<cfset var monthlyFee = "">
		
		<cfquery name="qGetPlanMonthlyFee" datasource="#application.dsn.wirelessAdvocates#">
			SELECT catalog.GetRateplanMonthlyFee(
						#arguments.CarrierId#
						,#arguments.CartPlanIDCount#
						,#int(arguments.LineNumber)#
						,#arguments.ProductId#
					) as MonthlyFee
		</cfquery>
		
		<cfif qGetPlanMonthlyFee.recordCount>
			<cfset monthlyFee = qGetPlanMonthlyFee.MonthlyFee>
		</cfif>
		<cfreturn monthlyFee>
	</cffunction>

	<cffunction name="getActivationFeeByProductIdAndLineNumber" access="public" output="false" returntype="string">
		<cfargument name="productId" type="numeric" required="true" />
		<cfargument name="lineNumber" type="numeric" required="true" />

		<cfset var local = arguments />

		<cfset local.monthlyFee = '' />
		<cfset local.carrierId = getCarrierIDbyPlanID( arguments.productId ) />

		<cfquery name="local.qGetPlanActivationFee" datasource="#application.dsn.wirelessAdvocates#">
			SELECT catalog.GetRateplanActivationFee(#arguments.productId#, #arguments.lineNumber#, #local.carrierId#) AS MonthlyFee
		</cfquery>

		<cfif local.qGetPlanActivationFee.recordCount>
			<cfset local.monthlyFee = local.qGetPlanActivationFee.monthlyFee />
		</cfif>

		<cfreturn local.monthlyFee />
	</cffunction>

	<cffunction name="getRateplanControlAvailability" access="public" output="false" returntype="boolean">
		<cfargument name="carrierId" type="numeric" required="true" />
		<cfargument name="planType" type="string" required="true" />
		<cfargument name="activationType" type="string" required="true" />
		<cfargument name="IsShared" type="boolean" default="false" required="false" />
		
		<cftry>
			<cfif arguments.IsShared>
				<cfreturn request.rateplanControl[arguments.carrierId]['Shared'][arguments.activationType] />
			<cfelse>
				<cfreturn request.rateplanControl[arguments.carrierId][arguments.planType][arguments.activationType] />
			</cfif>
			
			<cfcatch type="any">
				<cfreturn true />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getImportantPlanInformation" access="public" returntype="string">
		<cfargument name="productID" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">

		<!--- determine the carrier of this plan --->
		<cfset local.carrierID = application.model.Product.getCarrierIdByProductId(arguments.productID)>

		<!--- if this is a Verizon or Sprint plan --->
		<cfif local.carrierID eq "42" or local.carrierID eq "299">
			<!--- get the "stupid last minute verizon important plan information" --->
			<cfquery name="local.qStupidLastMinuteVerizonImportantPlanInformation" datasource="#application.dsn.wirelessAdvocates#">
				SELECT prop.[Value] as ImportantPlanInformation
				FROM catalog.Rateplan r
				INNER JOIN catalog.Product p ON r.RateplanGuid = p.ProductGuid
					AND p.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productID#">
				INNER JOIN catalog.Property prop ON prop.ProductGuid = p.ProductGuid
					AND prop.Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="TANDC">
			</cfquery>
			<cfif local.qStupidLastMinuteVerizonImportantPlanInformation.recordCount>
				<cfset local.return = trim(local.qStupidLastMinuteVerizonImportantPlanInformation.ImportantPlanInformation)>
			</cfif>
		</cfif>

		<cfreturn local.return>
	</cffunction>


	<cffunction name="getDefaultPlan" access="public" returntype="query">
		<cfargument name="productId" type="numeric" required="true" />
		<cfset qPlan = 0 />

		<cfquery name="qPlan" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
			--*
				rpd.RateplanGuid
				, rpd.DeviceGuid
				, rpd.IsDefaultRateplan
				, rpp.ProductId RateplanProductId
			FROM catalog.RateplanDevice rpd
			INNER JOIN catalog.Rateplan rp ON rp.RateplanGuid = rpd.RateplanGuid
			INNER JOIN catalog.Product rpp ON rpp.ProductGuid = rp.RateplanGuid
			INNER JOIN catalog.Device d ON d.DeviceGuid = rpd.DeviceGuid
			INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
			WHERE
				rp.Type IN ('IND','FAM')
				AND IsDefaultRateplan = 1
				AND dp.ProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer"  />
		</cfquery>
		<!--- TODO: Account for zip code market --->

		<cfreturn qPlan />
	</cffunction>


	<cffunction name="getFamilyPlanMaxLines" access="public" output="false" returntype="numeric">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfset var qPlan = '' />
		<cfset maxLines = 0 />

		<cfquery name="qPlan" datasource="#application.dsn.wirelessAdvocates#">
			SELECT IsNull(MaxLines, 1) MaxLines
			FROM catalog.RatePlan rp
			INNER JOIN catalog.Product p ON p.ProductGuid = rp.RateplanGuid
			WHERE p.ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer"  />
		</cfquery>

		<cfreturn qPlan.MaxLines>
	</cffunction>

	<cffunction name="getHasPlanDeviceCap" access="public" returntype="string" output="false">
		<cfargument name="ProductId" required="true" type="numeric" />
	
		<cfset var qPlan = '' />
		<cfset var hasPlanDeviceCap = false />
	
		<cfquery name="qServiceType" datasource="#application.dsn.wirelessAdvocates#">
			SELECT 
				IsNull( (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.ProductGuid = p.ProductGuid AND pp.Name = 'PLAID_DEVICE_CAP_INDICATOR'), 'N') HasPlanDeviceCap
			FROM catalog.Product p
			WHERE p.ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif qServiceType.RecordCount && qServiceType.HasPlanDeviceCap eq 'Y'>
			<cfset hasPlanDeviceCap = true />
		</cfif>
	
		<cfreturn hasPlanDeviceCap />
	</cffunction>


	<cffunction name="getIsShared" access="public" returntype="string" output="false">
		<cfargument name="ProductId" required="true" type="numeric" />
	
		<cfset var qPlan = '' />
		<cfset var IsShared = false />
	
		<cfquery name="qPlan" datasource="#application.dsn.wirelessAdvocates#">
			SELECT IsShared
			FROM catalog.Product p
			INNER JOIN catalog.RatePlan rp ON rp.RateplanGuid = p.ProductGuid
			WHERE p.ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif qPlan.RecordCount && qPlan.IsShared>
			<cfset IsShared = true />
		</cfif>
	
		<cfreturn IsShared />
	</cffunction>


	<cffunction name="getHasSharedServices" access="public" returntype="string" output="false">
		<cfargument name="ProductId" required="true" type="numeric" />
	
		<cfset var qPlan = '' />
		<cfset var HasSharedServices = false />
	
		<cfquery name="qPlan" datasource="#application.dsn.wirelessAdvocates#">
			SELECT IsShared
			FROM catalog.Product p
			INNER JOIN catalog.RatePlan rp ON rp.RateplanGuid = p.ProductGuid
			WHERE p.ProductId = <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif qPlan.RecordCount && qPlan.IsShared>
			<cfset HasSharedServices = true />
		</cfif>
	
		<cfreturn HasSharedServices />
	</cffunction>


	<cffunction name="getPlanDiscount" returntype="numeric">
		<cfargument name="CarrierId" type="numeric" required="true" />
		
		<cfset var planDiscount = 0 />
		
		<cfscript>
			switch( arguments.CarrierId )
			{
				case 42:
					planDiscount = request.config.PlanDiscount.Verizon;
					break;
				case 109:
					planDiscount = request.config.PlanDiscount.Att;
					break;
				case 128:
					planDiscount = request.config.PlanDiscount.Tmobile;
					break;
				case 299:
					planDiscount = request.config.PlanDiscount.Sprint;
					break;									
			}
		</cfscript>

		<cfreturn planDiscount />
	</cffunction>

<!--- TODO: revisit this when i've got more sleep and can figure out how to implement this
	<cffunction name="isRateplanConfigurationAllowed" access="public" output="false" returntype="boolean">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfargument name="LOBType" type="string" required="true">
		<cfargument name="DeviceId" type="numeric" required="false" default="0">
		<cfset var local = arguments>
		<cfset local.return = true>

		<cfquery name="local.CheckRateplanExceptions" datasource="#application.dsn.wirelessAdvocates#">
			<!--- check for carrier disabled --->
			select
				1
			from
				catalog.RateplanException re
				left join catalog.Rateplan r
					on r.CarrierGuid = re.CarrierGuid
				left join catalog.Product p_r
					on r.RateplanGuid = p.ProductGuid
					and p_r.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
				<cfif arguments.deviceid>
					left join catalog.Device d
						on re.DeviceGuid = d.DeviceGuid
					left join catalog.Product p_d
						on d.DeviceGuid = p_d.DeviceGuid
				</cfif>
			where
				( re.lobtype is null or re.lobtype = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.lobtype#"> )
			and ( re.plantype is null or re.plantype = r.plantype )
			and ( re.rateplanguid is null or re.rateplanguid = r.rateplanguid )
			and ( re.deviceguid is null or re.deviceguid

			union

			<!--- check for lob disabled --->
			select
				1
			from
				catalog.RateplanException re
			where
				re.lobtype = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.LOBType#">
			and re.carrierguid is null
			and re.plantype is null
			and re.rateplanguid is null
			and re.deviceguid is null


		</cfquery>

		<cfreturn local.return>
	</cffunction>
--->

<!--- TRV: deprecated methods from MVC-1 (TODO: get rid of these as MVC-2 solidifes in functionality)

	<cffunction name="getByPhone" returntype="query">
		<cfargument name="phoneid" type="string" default="">
		<cfset var local = structNew()>

		<cfquery name="local.qPhonePlans" datasource="Cartoys_Wireless">
			SELECT
				p.*
			FROM
				dn_Plans p
			WHERE exists (
				SELECT
					1
				FROM
					ctproductprice pp
					inner join ctProduct ctp
						on ctp.ProductID = pp.PlanID
				WHERE
					pp.productid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.phoneID#">
				AND	ctp.ProductTypeCode = 'PLAN'
				AND	ctp.Active = '1'
			)
		</cfquery>

		<cfreturn local.qPhonePlans />
	</cffunction>

	<cffunction name="getByCarrier" returntype="query">
		<cfargument name="carrierid" type="string" default="">
		<cfset var local = structNew()>

		<cfquery name="local.getPlanByCarrier" datasource="Cartoys_Wireless">
		SELECT planid, planname, carrierid, cellfamilyplan, cellcallforpricing, anytimeminutes, offpeakminutes, mobtomobcall,
			wirelessinternet, monthly_fee,roaming,longdistance,PlanPrice, priceperadditionalline
		FROM vPlanMarkets
		WHERE planid IN(
			SELECT distinct PlanID
			FROM ctproductprice inner join
				ctProduct on ctProduct.ProductID = ctProductPrice.PlanID
			WHERE ctProduct.ProductTypeCode='PLAN'
				AND ctProduct.Active = '1'
				AND ctProduct.ManufacturerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.carrierid#"/>
		)
		order by planname, planprice
		</cfquery>

		<cfreturn local.getMostFreePlans />
	</cffunction>

<!--- TODO: verify that search index doesn't call this method --->
	<cffunction name="getAll" returntype="query">
		<cfset var local = structNew()>

		<cfquery name="local.getPlans" datasource="Cartoys_Wireless">
		SELECT planid, planname, carrierid, cellfamilyplan, cellcallforpricing, anytimeminutes, offpeakminutes, mobtomobcall,
			wirelessinternet, monthly_fee,roaming,longdistance,PlanPrice, priceperadditionalline
		FROM vPlanMarkets
		order by planname, planprice
		</cfquery>

		<cfreturn local.getPlans />
	</cffunction>

	<cffunction name="getPlansBySalesAreas" returntype="query">
		<cfargument name="salesAreas" type="string" required="true"> <!--- expected to be a list of numeric salesAreaID values --->
		<cfargument name="getPlanIDsOnly" type="boolean" default="false">
		<cfset var local = structNew()>

		<cfquery name="local.qPlansBySalesAreas" datasource="#application.dsn.wirelessAdvocates#">
			select
			<cfif not arguments.getPlanIDsOnly>
				plans.*
			<cfelse>
				plans.planId
			</cfif>
			from
				dn_Plans plans
			where exists (
				SELECT
					1
				FROM
					CTProduct p
					inner join dbo.Products cp
						on cp.PartNumber =  CAST(p.ProductId AS varchar(10))
						and cp.Active = 1
				where
					exists (
						select 1
						from CTSalesAreaProduct sap
						where sap.SalesAreaID in ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.salesAreas#" list="true"> )
						and sap.ProductId = p.ProductId
					)
				and p.active = 1
				and p.ProductTypeCode = 'PLAN'
				and p.Name NOT LIKE '2YR%'
				and p.Name = plans.planName
			)
		</cfquery>

		<cfreturn local.qPlansBySalesAreas>
	</cffunction>

    <cffunction name="getPlanStringIDByPlanID" returntype="any">
    	<cfargument name="planID" type="string" required="true">
        <cfset var local = structNew()>
        <cfset local.planId = arguments.planID>

        <cfquery name="local.qGetPlanStringIDByPlanId" datasource="#application.dsn.wirelessAdvocates#">
        	select CAST(ManufacturerId as varchar(10)) + '|' + dbo.fnStripNonAlphaNumeric(p.name) as planStringId
            from
                CTProduct p
            where
                ProductId =  <cfqueryparam cfsqltype="cf_sql_integer" value="#local.planId#">
        </cfquery>

        <cfreturn local.qGetPlanStringIDByPlanId.planStringId>
    </cffunction>

	<cffunction name="getPlanIDByPlanStringIDAndZipcode" returntype="any">
		<cfargument name="planStringID" type="string" required="true">
		<cfargument name="zipcode" type="string" default="">
		<cfset var local = structNew()>

		<cfif len(trim(arguments.zipcode))>
			<!--- get the market areas for the supplied zipcode --->
			<cfset local.qMarkets = application.model.Market.getByZipCode(listFirst(arguments.zipcode,"-"))>
			<cfset local.marketList = valueList(local.qMarkets.marketid)>
		</cfif>

		<cfquery name="local.qGetPlanIDByPlanStringIDAndZipcode" datasource="#application.dsn.wirelessAdvocates#">
			SELECT <cfif not len(trim(arguments.zipcode))>TOP 1</cfif>
				plans.ProductID as PlanID
			FROM
				CTProduct plans
			WHERE exists (
				SELECT
					1
				FROM
					CTProduct p
					inner join dbo.Products cp
						on cp.PartNumber =  CAST(p.ProductId AS varchar(10))
						and cp.Active = 1
				where
					exists (
						select 1
						from CTSalesAreaProduct sap
						where 1=1
						<cfif len(trim(arguments.zipcode))>
						and sap.SalesAreaID in ( <cfqueryparam cfsqltype="cf_sql_integer" value="#local.marketList#" list="true"> )
						</cfif>
						and sap.ProductId = p.ProductId
					)
				and p.active = 1
				and p.ProductTypeCode = 'PLAN'
				and p.Name NOT LIKE '2YR%'
				and p.productID = plans.productID
				and p.manufacturerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(arguments.planStringID,"|")#">
				and dbo.fnStripNonAlphaNumeric(p.name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(arguments.planStringID,"|")#">
			)
		</cfquery>

		<cfreturn valueList(local.qGetPlanIDByPlanStringIDAndZipcode.planID)>
	</cffunction>

	<cffunction name="getCarrierIDbyPlanStringID" returntype="numeric">
		<cfargument name="planStringID" type="string" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qPlanCarrierID" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				carrierID
			FROM
				dn_Plans
			WHERE
				cast(carrierID AS varchar) + '|' + dbo.fnStripNonAlphaNumeric(planName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.planStringID#">
		</cfquery>
		<cfreturn local.qPlanCarrierID.carrierID>
	</cffunction>

	<cffunction name="getPlanTypeByPlanStringID" returntype="string">
		<cfargument name="planStringID" type="string" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qPlanType" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				planType
			FROM
				dn_Plans
			WHERE
				cast(carrierID AS varchar) + '|' + dbo.fnStripNonAlphaNumeric(planName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.planStringID#">
		</cfquery>
		<cfreturn local.qPlanType.planType>
	</cffunction>

--->

</cfcomponent>
