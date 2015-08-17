<cfcomponent output="false" displayname="AdminPhone">

	<cffunction name="init" returntype="AdminPhone">
    	<cfreturn this />
    </cffunction>


	<cffunction name="checkUPC" output="false" returntype="numeric">
		<cfargument name="productGuid" type="string" />
		<cfargument name="upc" type="string" />
		<cfargument name="manfGuid" type="string" />

		<cfset var local = {
			productGuid = arguments.productGuid,
			upc = arguments.upc,
			manfGuid = arguments.manfGuid
		} />

		<cftry>
			<cfquery name="local.isUPC" datasource="#application.dsn.wirelessadvocates#">
				SELECT COUNT(*) as UpcCount
				FROM catalog.Device
				WHERE UPC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.upc#" />
					AND ManufacturerGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manfGuid#" />
					AND DeviceGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn local.isUPC.UpcCount />
	</cffunction>

	<cffunction name="clonePhone" returntype="any">
		<cfargument name="deviceGuid" type="string" />
		<cfargument name="deviceUPC" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_Device" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.deviceUPC#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.deviceGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
	</cffunction>

	<cffunction name="cloneMasterPhone" returntype="any">
		<cfargument name="deviceGuid" type="string" />
		<cfargument name="name" type="string" />
		<cfargument name="newUPC" type="string" />
		<cfargument name="oldSKU" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_MasterDevice" datasource="#application.dsn.wirelessadvocates#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.productId#"><!--- ProductId --->
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.newUPC#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.name#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.oldSku#">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.deviceGuid#">
			<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#arguments.accessoryGersSku#">
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.channelId#" ><!--- channelId --->
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.active#" ><!--- active --->
			<cfprocresult name="newProductGuid">
		</cfstoredproc>

		<cfreturn newProductGuid.newGuid />
	</cffunction>

	<cffunction name="getPhone" returntype="query">
		<cfargument name="DeviceId" required="no" default="">

		<cfset var local = structNew()>
		<cfset local.deviceId = arguments.DeviceId />

		<cftry>
			<cfquery name="local.getPhone" datasource="#application.dsn.wirelessadvocates#">
				select
					d.DeviceGuid
					, d.Name
					, d.DeviceGuid
					, d.UPC
					, IsNull(p.Active,0) as Active
					, ISNULL(c.CompanyName,'') as Carrier
					, c.CompanyGuid as CarrierGUID
					, d.ManufacturerGuid
					, m.CompanyName as MANUFACTURER
					, p.GERSSKU as GERSSKU
					, p.ProductId
					, IsNull((select value from catalog.Property where Name = 'Title' and ProductGuid = d.DeviceGuid),'') Title
					, IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = d.DeviceGuid),'') ShortDescription
					, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = d.DeviceGuid),'') LongDescription
					, IsNull((select value from catalog.Property where Name = 'MetaDescription' and ProductGuid = d.DeviceGuid),'') MetaDescription
					, IsNull((select value from catalog.Property where Name = 'MetaKeywords' and ProductGuid = d.DeviceGuid),'') MetaKeywords
					, IsNull((select value from catalog.Property where Name = 'ReleaseDate' and ProductGuid = d.DeviceGuid),'') ReleaseDate
					, IsNull((select value from catalog.Property where Name = 'Inventory.HoldBackQty' and ProductGuid = d.DeviceGuid),'') SafteyStock
					, p.channelID
					, ch.channel
				from catalog.Device d
					inner join catalog.ProductGuid pg on pg.ProductGuid = d.DeviceGuid
					left join catalog.Company c on c.CompanyGuid = d.CarrierGuid
					left join catalog.Company m on m.CompanyGuid = d.ManufacturerGuid
					left join catalog.Product p on p.ProductGuid = pg.ProductGuid
					left join catalog.channel ch on ch.channelID = p.channelID
				where
					d.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#">
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getPhone>

	</cffunction>

	<!--- 
		Create a list of phones that is sorted by matching guid so all phones descended from the same master record are sorted together. 
		To facilitate this and to eliminate the need to code a monstrous union a new view (catalog.dn_MasterPhones) was created to simply
		the sql and maintain any time this union/join needs to be performed.
	--->
	<cffunction name="getPhones" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />

		<cfset var local = { filter = arguments.filter } />

		<cftry>
			
			<!--- if we are channel filtering then do this query first to find the matching guids --->
			<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel) and local.filter.channel gt 1 >	
				<cfquery name="local.getMatchingGuids" datasource="#application.dsn.wirelessadvocates#" >
					SELECT * FROM catalog.dn_MasterPhones                           
					WHERE ProductTypeId =	1
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
			
			<cfquery name="local.getPhones" datasource="#application.dsn.wirelessadvocates#">
				SELECT * FROM catalog.dn_MasterPhones                           
				WHERE ProductTypeId =	1
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
			<cfset qry = local.getphones /> 
			<cfquery name="local.getPhones2" dbtype="query">
				select * from qry
				<cfif listlen(quotedValueList(local.getMatchingGuids.MatchingGUID))>
					where MatchingGUID				
						 in (#quotedValueList(local.getMatchingGuids.MatchingGUID)#)
				</cfif>
				ORDER BY [MatchingGUID], Channel DESC, name, title	
			</cfquery>
			</cfif>
				<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfif structKeyExists(local,"getPhones2")>
			<cfreturn local.getPhones2 />
		<cfelse>
			<cfreturn local.getPhones />
		</cfif>
	</cffunction>

	<cffunction name="insertPhone" returntype="string">
		<cfargument name="form" type="struct" required="true" />
		<cfargument name="prodguid" type="string" required="false" default="" />

		<cfset var local = {
				name = arguments.form.name
				, upc = arguments.form.upc
				, productGuid = arguments.form.productGuid
				, carrierId = arguments.form.carriers
				, manufacturerId = arguments.form.manufacturers
				, title = arguments.form.title
				, shortDescription = arguments.form.ShortDescription
				, longDescription = arguments.form.longDescription
				, active = false
				, gersSku = arguments.form.gersSku
				, productTypeId = application.model.Utility.getProductTypeId("Device")
				, ReleaseDate = arguments.form.ReleaseDate
				, channelID = arguments.form.channelID
				, SafteyStock = arguments.form.SafteyStock
			} />

		<cfif local.productGuid EQ "">
			<cfif arguments.prodguid is not "">
				<!--- Just use the one that was passed --->
				<cfset local.productGuid = arguments.prodguid />
			<cfelse>
				<!--- Make A Microsoft/DCE standard Guid by inserting dash at position 23 of a cf created uuid --->
				<cfset local.productGuid = Insert("-", CreateUUID(), 23) />
			</cfif>
		</cfif>

		<cfif StructKeyExists(arguments.form, "active")>
			<cfif arguments.form.active NEQ false>
				<cfset local.active = true />
			</cfif>
		</cfif>

		<cfset application.model.AdminProductGuid.insertProductGuid(local.productGuid, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.productGuid, local.gersSku, local.active, local.channelID) />

		<cftry>
			<cfquery name="local.insertPhone" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.Device (
					DeviceGuid,
					CarrierGuid,
					ManufacturerGuid,
					UPC,
					Name
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manufacturerId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.upc#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.Name#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the accessory properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "title", local.title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "ReleaseDate", local.ReleaseDate, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "Inventory.HoldBackQty", local.SafteyStock, "Mac") /> <!--- TODO: update user --->

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="updatePhone" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
			productGuid = arguments.form.productGuid,
			upc = arguments.form.upc,
			carrierId = arguments.form.carriers,
			manufacturerId = arguments.form.manufacturers,
			name = arguments.form.name,
			title = arguments.form.title,
			shortDescription = arguments.form.ShortDescription,
			longDescription = arguments.form.longDescription,
			active = false,
			gersSku = arguments.form.gersSku,
			metaDescription = arguments.form.metaDescription,
			metaKeywords = arguments.form.metaKeywords,
			ReleaseDate = arguments.form.ReleaseDate,
			channelId = arguments.form.channelID,
			SafteyStock = arguments.form.SafteyStock
		} />

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.active = true />
		</cfif>

		<!--- query to update product table --->
		<cfset application.model.AdminProduct.updateProduct(local.productGuid, local.gersSku, local.active, local.channelId) />

		<cftry>
			<!--- updates table --->
			<cfquery name="local.updatePhone" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.Device
				SET ManufacturerGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manufacturerId#" />,
					CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.carrierId#" />,
					UPC = <cfqueryparam cfsqltype="cf_sql_char" value="#local.upc#" maxlength="12" />
				WHERE DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "title", local.title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "shortDescription", local.shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "longDescription", local.longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "metaDescription", local.metaDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "metaKeywords", local.metaKeywords, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "ReleaseDate", local.ReleaseDate, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.productGuid, "Inventory.HoldBackQty", local.SafteyStock, "Mac") /> <!--- TODO: update user --->

		<cfreturn "success" />
	</cffunction>


	<cffunction name="updateDefaultDevicePlan" output="false" access="public" returntype="string">
		<cfargument name="phoneGuid" type="string" required="true" />
		<cfargument name="isDefaultRateplanGuid" type="string" required="true" />

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			-- Clear defaults
			UPDATE catalog.RateplanDevice
			SET IsDefaultRateplan = 0
			WHERE DeviceGuid = <cfqueryparam value="#arguments.phoneGuid#" cfsqltype="cf_sql_varchar" />

			-- Set default
			UPDATE catalog.RateplanDevice
			SET IsDefaultRateplan = 1
			WHERE
				RateplanGuid = <cfqueryparam value="#arguments.isDefaultRateplanGuid#" cfsqltype="cf_sql_varchar" />
				AND DeviceGuid = <cfqueryparam value="#arguments.phoneGuid#" cfsqltype="cf_sql_varchar" />
		</cfquery>

	</cffunction>

	<cffunction name="getMasterPhone" access="public" output="false" returntype="struct" hint="Returns the data for the Master Channel device pased on productID">
		<cfargument name="productId" type="any" required="true" />
		<cfset var masterData = "" />
		<cfset var local = structNew()>
		<cftry>
			<cfquery name="masterData" datasource="#application.dsn.wirelessadvocates#" >
				SELECT IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = d.DeviceGuid),'') ShortDescription
					, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = d.DeviceGuid),'') LongDescription
				FROM catalog.Device d
					INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = d.DeviceGuid
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
