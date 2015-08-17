<cfcomponent output="false" displayname="AdminPlan">

	<cffunction name="init" returntype="AdminPlan">
		<cfreturn this>
	</cffunction>

	<cffunction name="clonePlan" returntype="string">
		<cfargument name="productGuid" type="string" />
		<cfargument name="deviceUPC" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<!--- clone plan --->
		<cfstoredproc procedure="clone.usp_Rateplan" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.deviceUPC#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.productGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
	</cffunction>

	<cffunction name="cloneMasterPlan" returntype="string">
		<cfargument name="productGuid" type="string" />
		<cfargument name="name" type="string" />
		<cfargument name="newUPC" type="string" />
		<cfargument name="oldSKU" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<!--- clone plan --->
		<cfstoredproc procedure="clone.usp_MasterRateplan" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.newUPC#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.name#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.oldSku#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.productGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
	</cffunction>


	<cffunction name="clonePlanProperties" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
		originalProductGuid = arguments.originalProductGuid,
		newProductGuid = arguments.newProductGuid
		} />

		<!--- get productId by productGuid --->
		<cfset local.origProductId = application.model.Utility.getProductId(local.originalProductGuid) />
		<cfset local.newProductId = application.model.Utility.getProductId(local.newProductGuid) />

		<!--- grab features for original product --->
		<cfset local.featureProperties = application.model.PropertyManager.getPropertiesByProductId(local.originalProductGuid, "features")>
		<cfloop query="local.featureProperties">
			<!--- insert the property --->
			<cfquery name="local.insertProperty" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.Property
				(
					ProductGuid
					,PropertyGuid
					,IsCustom
					,LastModifiedDate
					,LastModifiedBy
					,CarrierPropertyName
					,GroupLabel
					,PropertyLabel
					,PropertyMasterGuid
					,PropertyType
					,Value
					,Active
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.newProductGuid#">
					,newid()
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.featureProperties.IsCustom#">
					,getdate()
					<!--- todo: implement user --->
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.LastModifiedBy)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.CarrierPropertyName)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.GroupLabel)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.PropertyLabel)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.PropertyMasterGuid)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.PropertyType)#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.featureProperties.value)#">
					,<cfqueryparam cfsqltype="cf_sql_bit" value="#local.featureProperties.active#">
				)
			</cfquery>
		</cfloop>

		<cfset local.specProperties = application.model.PropertyManager.getPropertiesByProductId(local.originalProductGuid, "specifications")>

		<cfloop query="local.specProperties">
			<cfset application.model.PropertyManager.insertProperty(local.newProductGuid, local.specProperties.PROPERTYMASTERGUID, local.specProperties.value, local.specProperties.value, "Mac") />
		</cfloop>
	</cffunction>

	<cffunction name="getPlan" returntype="query">
		<cfargument name="PlanId" required="yes" default="">
		<cfset var local = structNew()>
		<cfset local.PlanId = arguments.PlanId>

		<cftry>
			<cfquery name="local.getPlan" datasource="#application.dsn.wirelessadvocates#">
				SELECT
					r.RateplanGuid,
					p.ProductId,
					r.CarrierGuid,
					r.Title as Name,
					r.CarrierBillCode,
					r.ContractTerm,
					r.IncludedLines,
					r.MaxLines,
					r.MonthlyFee,
					r.AdditionalLineFee,
					r.type,
					r.IsShared,
					r.primaryActivationFee,
					p.GersSku as GersSku,
					IsNull(p.Active,0) as Active,
					ISNULL(c.CompanyName,'') as Carrier,
					IsNull((select value from catalog.Property where Name = 'Title' and ProductGuid = r.RatePlanGuid),'') as Title,
					IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = r.RatePlanGuid),'') as ShortDescription,
					IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = r.RatePlanGuid),'') as LongDescription,
					IsNull((select value from catalog.Property where Name = 'MetaKeywords' and ProductGuid = r.RatePlanGuid),'') as MetaKeywords,
					IsNull((select value from catalog.Property where Name = 'DataLimitGb' and ProductGuid = r.RatePlanGuid),'') as DataLimitGb,
					IsNull((select value from catalog.Property where Name = 'BasicFee' and ProductGuid = r.RatePlanGuid),'') as BasicFee,
					IsNull((select value from catalog.Property where Name = 'SmartphoneFee' and ProductGuid = r.RatePlanGuid),'') as SmartphoneFee,
					IsNull((select value from catalog.Property where Name = 'MifiFee' and ProductGuid = r.RatePlanGuid),'') as MifiFee,
					ch.channelID,
					ch.channel

				FROM catalog.Rateplan r
					INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = r.RateplanGuid
					LEFT JOIN catalog.Company c on c.CompanyGuid = r.CarrierGuid
					LEFT JOIN catalog.Product p on p.ProductGuid = pg.ProductGuid
					LEFT JOIN catalog.channel ch ON ch.channelID = p.channelID
				WHERE
				r.RatePlanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.PlanId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getPlan>
	</cffunction>

	<cffunction name="getPlanCarrier" returntype="query">
		<cfargument name="PlanId" required="yes" default="" />

		<cfset var local = structNew()>
		<cfset local.PlanId = arguments.PlanId>

		<cftry>
			<cfquery name="local.getPlanCarrier" datasource="#application.dsn.wirelessadvocates#">
				select
					r.CarrierGuid,
					ISNULL(c.CompanyName,'') as Carrier
				from
					catalog.Rateplan r
					left join
						catalog.Company c on c.CompanyGuid = r.CarrierGuid
				where
					r.RatePlanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.PlanId#">
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getPlanCarrier />
	</cffunction>

	<cffunction name="getPlans" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />

		<cfset var local = { filter = arguments.filter } />

		<cftry>
			
			<!--- if we are channel filtering then do this query first to find the matching guids --->
			<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel) and local.filter.channel gt 1 >	
				<cfquery name="local.getMatchingGuids" datasource="#application.dsn.wirelessadvocates#" >
					SELECT *, [SOC Code] as CarrierBillCode FROM catalog.dn_MasterRatePlans                           
					WHERE ProductTypeId =	2
					<cfif StructKeyExists(local.filter, "active") and Len(local.filter.active)>
						AND	ISNULL(Active, 0)	= <cfqueryparam value="#local.filter.active#" cfsqltype="cf_sql_integer" />
					</cfif>
	            	<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
	            		AND	CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
	            	</cfif>
	            	<cfif structKeyExists(local.filter, 'createDate_start') and Len(local.filter.createDate_start)>
	            		AND	createDate >= <cfqueryparam value="#local.filter.createDate_start#" cfsqltype="cf_sql_date" />
	            	</cfif>
	            	<cfif structKeyExists(local.filter, 'createDate_end') and Len(local.filter.createDate_end)>
	            		AND	createDate <= <cfqueryparam value="#local.filter.createDate_end#" cfsqltype="cf_sql_date" />
	            	</cfif>

	            	<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel)>
						<cfif local.filter.channel eq 'unassigned'>
							AND channelId = 0
						<cfelseif local.filter.channel eq 'master'>
							AND channelId = 1
						<cfelseif local.filter.channel eq 'costco'>
							AND channelId = 2
						<cfelseif local.filter.channel eq 'aafes'>
							AND channelId = 3
						<cfelseif local.filter.channel eq 'cartoys'>
							AND channelId = 4
						<cfelseif local.filter.channel eq 'pagemaster'>
							AND channelId = 5
						</cfif>
					<cfelse>
						AND channelID <> 0						
					</cfif>	
				</cfquery>
			</cfif>
			
			<cfquery name="local.getPlans" datasource="#application.dsn.wirelessadvocates#">
				SELECT *, [SOC Code] as CarrierBillCode FROM catalog.dn_MasterRatePlans                           
				WHERE ProductTypeId =	2
				<cfif StructKeyExists(local.filter, "active") and Len(local.filter.active)>
					AND	ISNULL(Active, 0)	= <cfqueryparam value="#local.filter.active#" cfsqltype="cf_sql_integer" />
				</cfif>
            	<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
            		AND	CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'createDate_start') and Len(local.filter.createDate_start)>
            		AND	createDate >= <cfqueryparam value="#local.filter.createDate_start#" cfsqltype="cf_sql_date" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'createDate_end') and Len(local.filter.createDate_end)>
            		AND	createDate <= <cfqueryparam value="#local.filter.createDate_end#" cfsqltype="cf_sql_date" />
            	</cfif>
            	<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel)>
					<cfif local.filter.channel eq 'unassigned'>
						AND channelId = 0
					<cfelseif local.filter.channel eq 'master'>
						AND channelId = 1
					<cfelseif local.filter.channel eq 'costco'>
						AND channelId in (1,2)
					<cfelseif local.filter.channel eq 'aafes'>
						AND channelId in (1,3)
					<cfelseif local.filter.channel eq 'cartoys'>
						AND channelId in (1,4)
					<cfelseif local.filter.channel eq 'pagemaster'>
						AND channelId in (1,5)
					</cfif>
				<cfelse>
						AND channelID <> 0						
				</cfif>
				ORDER BY [MatchingGUID], Channelid
			</cfquery>
			
			<!---
				This query of a query is used so that when the filtering eliminates the master record things are still grouped properly
			 --->
			<cfif structKeyExists(local,"getMatchingGuids")>
			<cfset qry = local.getPlans /> 
			<cfquery name="local.getPlans2" dbtype="query">
				select * from qry
				where MatchingGUID				
					 in (#quotedValueList(local.getMatchingGuids.MatchingGUID)#)
				ORDER BY [MatchingGUID], Channel DESC, name, title	
			</cfquery>
			</cfif>
				<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfif structKeyExists(local,"getPlans2")>
			<cfreturn local.getPlans2 />
		<cfelse>
			<cfreturn local.getPlans />
		</cfif>
	</cffunction>

	<cffunction name="insertPlan" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				name = arguments.form.name,
				productId = arguments.form.planGuid,
				carrierId = arguments.form.carrierGuid,
				carrierBillCode = arguments.form.billCode,
				contractTerm = arguments.form.contractTerm,
				includedLines = arguments.form.includedLines,
				maxLines = arguments.form.maxLines,
				monthlyFee = arguments.form.monthlyFee,
				lineFee = arguments.form.lineFee,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
        		MetaKeywords = arguments.form.MetaKeywords,
				DataLimitGb = arguments.form.DataLimitGb,
				active = false,
				type=arguments.form.type,
				IsShared = arguments.form.IsShared,
				gersSku = arguments.form.gersSku,
				productTypeId = application.model.Utility.getProductTypeId("Rateplan"),
				channelID = arguments.form.channelID,
				primaryActivationFee = arguments.form.primaryActivationFee,
				basicFee = arguments.form.basicFee,
				smartphoneFee = arguments.form.smartphoneFee,
				mifiFee = arguments.form.mifiFee
			} />

		<cfif local.productId EQ "">
			<cfset local.productId = Insert("-", CreateUUID(), 23) />
		</cfif>

		<cfif StructKeyExists(arguments.form, "active")>
			<cfif arguments.form.active NEQ false>
				<cfset local.active = true />
			</cfif>
		</cfif>

		<cfif local.monthlyFee EQ "">
			<cfset local.monthlyFee = 0.00 />
		</cfif>

		<cfif local.lineFee EQ "">
			<cfset local.lineFee = 0.00 />
		</cfif>

		<cfif local.contractTerm EQ "">
			<cfset local.contractTerm = 0 />
		</cfif>

		<cfif local.includedLines EQ "">
			<cfset local.includedLines = 0 />
		</cfif>

		<cfif local.maxLines EQ "">
			<cfset local.maxLines = 0 />
		</cfif>

		<cfset application.model.AdminProductGuid.insertProductGuid(local.productId, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.productId, local.gersSku, local.active, local.channelID) />

		<cftry>
			<cfquery name="local.insertPlan" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.Rateplan (
					RateplanGuid,
					CarrierGuid,
					CarrierBillCode,
					Title,
					ContractTerm,
					IncludedLines,
					MaxLines,
					MonthlyFee,
					AdditionalLineFee,
					Type,
					IsShared,
					primaryActivationFee
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.productId)#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.carrierId)#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.carrierBillCode)#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.name)#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.contractTerm#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.includedLines#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.maxLines#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#local.lineFee#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.type)#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#trim(local.IsShared)#" />,
					<cfqueryparam cfsqltype="cf_sql_money" value="#trim(local.primaryActivationFee)#">
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- add the plan properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "title", local.title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "MetaKeywords", local.MetaKeywords, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "DataLimitGB", local.DataLimitGb, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "BasicFee", local.basicFee, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "SmartphoneFee", local.smartphoneFee, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "MifiFee", local.mifiFee, "Mac") /> <!--- TODO: update user --->

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="isCarrierBillCodeUnique" returntype="numeric">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				billCode = arguments.form.billCode,
				planGuid = arguments.form.planGuid,
				carrierGuid = arguments.form.carrierGuid
			} />

		<cftry>
			<cfquery name="local.isBillCodeUnique" datasource="#application.dsn.wirelessadvocates#">
				SELECT *
				FROM Catalog.Rateplan r
				WHERE CarrierBillCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.billCode#" />
					AND CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierGuid#" />)
					<cfif local.planGuid NEQ "">
					  	AND RateplanGuid <> UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planGuid#">)
					</cfif>
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.isBillCodeUnique.RecordCount />
	</cffunction>

	<cffunction name="updatePlan" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				productId = arguments.form.planGuid,
				active = false,
				carrierId = arguments.form.carrierGuid,
				carrierBillCode = arguments.form.billCode,
				contractTerm = arguments.form.contractTerm,
				gersSku = arguments.form.gersSku,
				includedLines = arguments.form.includedLines,
				maxLines = arguments.form.maxLines,
				monthlyFee = arguments.form.monthlyFee,
				lineFee = arguments.form.lineFee,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				metaKeywords = arguments.form.metaKeywords,
				DataLimitGb = arguments.form.DataLimitGb,
				type = arguments.form.type,
				IsShared = arguments.form.IsShared,
				channelId = arguments.form.channelID,
				primaryActivationFee = arguments.form.primaryActivationFee,
				basicFee = arguments.form.basicFee,
				smartphoneFee = arguments.form.smartphoneFee,
				mifiFee = arguments.form.mifiFee
			} />

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.active = true />
		</cfif>

		<cfif local.contractTerm eq "">
			<cfset local.contractTerm = 0 />
		</cfif>

		<cfif local.includedLines eq "">
			<cfset local.includedLines = 0 />
		</cfif>
		<cfif local.maxLines eq "">
			<cfset local.maxLines = 0 />
		</cfif>
		<cfif local.monthlyFee eq "">
			<cfset local.monthlyFee = 0 />
		</cfif>
		<cfif local.lineFee eq "">
			<cfset local.lineFee = 0 />
		</cfif>
		<!--- query to update product table --->
		<cfset application.model.AdminProduct.updateProduct(local.productId, local.gersSku, local.active, local.channelId) />

		<cftry>
			<!--- updates accessory table --->
			<cfquery name="local.updatePhone" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.Rateplan
				SET CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.carrierId)#" />,
					ContractTerm = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.contractTerm#" />,
					IncludedLines = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.includedLines#" />,
					MaxLines = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.maxLines#" />,
					MonthlyFee = <cfqueryparam cfsqltype="cf_sql_money" value="#local.monthlyFee#" />,
					AdditionalLineFee = <cfqueryparam cfsqltype="cf_sql_money" value="#local.lineFee#" />,
					Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.type)#" />,
					IsShared = <cfqueryparam cfsqltype="cf_sql_bit" value="#trim(local.IsShared)#" />,
					primaryActivationFee = <cfqueryparam cfsqltype="cf_sql_money" value="#trim(local.primaryActivationFee)#">
				WHERE RateplanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(local.productId)#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the plan properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "title", local.title,  "Mac") /><!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "DataLimitGB", local.DataLimitGb, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "metaKeywords", local.metaKeywords, "Mac") />
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "BasicFee", local.basicFee, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "SmartphoneFee", local.smartphoneFee, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productId, "MifiFee", local.mifiFee, "Mac") /> <!--- TODO: update user --->
		<!--- TODO: update user --->

		<cfreturn "success" />
	</cffunction>

	<cffunction name="getMasterPlan" access="public" output="false" returntype="struct" hint="Returns the data for the Master Channel device pased on productID">
		<cfargument name="productId" type="any" required="true" />
		<cfset var masterData = "" />
		<cfset var local = structNew()>
		<cftry>
			<cfquery name="masterData" datasource="#application.dsn.wirelessadvocates#" >
				SELECT IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = rp.RatePlanGuid),'') ShortDescription
					, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = rp.RatePlanGuid),'') LongDescription
				FROM catalog.ratePlan rp
					INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = rp.RatePlanGuid
					LEFT JOIN catalog.Product p on p.ProductGuid = pg.ProductGuid
				WHERE p.productId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#"> and p.channelId = 1
			</cfquery>

			<cfloop query="masterData">
				<cfset local["ShortDescription"] = masterData.ShortDescription>
				<cfset local["LongDescription"] = masterData.LongDescription>
			</cfloop>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn local />
	</cffunction>

	<cffunction name="getChannelId" access="public" output="false" returntype="numeric" hint="">
		<cfargument name="productGuid" type="string" required="true" />
		<cfset var local = {} />
		<cfset local.query = '' />

		<cfquery name="local.query" datasource="#application.dsn.wirelessadvocates#" >
			SELECT channelId
			FROM catalog.product
			WHERE productGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productGuid#">
		</cfquery>

		<cfset local.channelId = local.query.channelId />

		<cfreturn local.channelId />
	</cffunction>

</cfcomponent>
