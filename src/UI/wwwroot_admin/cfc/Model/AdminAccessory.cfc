<cfcomponent output="false" displayname="AdminAccessory">

	<cffunction name="init" returntype="AdminAccessory">
		<cfreturn this>
	</cffunction>

	<cffunction name="checkUPC" output="false" returntype="numeric">
		<cfargument name="productGuid" type="string" />
		<cfargument name="upc" type="string" />
		<cfargument name="manfGuid" type="string" />

		<cfset var local = {
				productGuid = arguments.productGuid,
				upc = arguments.upc,
				manfGuid = arguments.manfGuid,
				upcCount = 0
			} />

		<cftry>
			<cfquery name="local.isUPC" datasource="#application.dsn.wirelessadvocates#">
				SELECT COUNT(*) as UpcCount
				FROM catalog.Accessory
				WHERE UPC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.upc#" />
					AND ManufacturerGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manfGuid#" />
					AND AccessoryGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfif local.isUPC.recordcount gt 0>
				<cfset local.upcCount = UpcCount>
			</cfif>
			<cfcatch type="any">

			</cfcatch>
		</cftry>
		<cfreturn local.upcCount />
	</cffunction>

	<cffunction name="deleteAccessory" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />

		<cfset var local = { accessoryId = arguments.accessoryId } />

		<!--- query to remove from productguid table --->
		<cfset application.model.AdminProductGuid.deleteProductGuid(local.accessoryId) />

		<!--- query to remove from product table --->
		<cfset application.model.AdminProduct.deleteProduct(local.accessoryId) />

		<!--- query to remove from accessory table --->
		<cftry>
			<cfquery name="local.deleteAccessory" datasource="#application.dsn.wirelessadvocates#">
				DELETE FROM Catalog.Accessory
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.productGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<!--- todo: query to remove properties for product --->
	</cffunction>

	<cffunction name="getAccessories" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		<cfargument name="carrier" required="false" default="" type="string" />

		<cfset var local = { filter = arguments.filter } />

		<cftry>
			
			<!--- if we are channel filtering then do this query first to find the matching guids --->
			<cfif structKeyExists(local.filter, 'channel') and Len(local.filter.channel) and local.filter.channel gt 1 >	
				<cfquery name="local.getMatchingGuids" datasource="#application.dsn.wirelessadvocates#" >
					SELECT * FROM catalog.dn_MasterAccessories                           
					WHERE ProductTypeId =	4
					<cfif StructKeyExists(local.filter, "isActive") and Len(local.filter.isActive)>
						AND	ISNULL(active, 0)	= <cfqueryparam value="#local.filter.isActive#" cfsqltype="cf_sql_integer" />
					</cfif>
					
					<!--- Uncomment this once the isFree column has been added to catalog.dn_MasterAccessories --->
					<cfif StructKeyExists(local.filter, "isFree") and Len(local.filter.isFree)>
						AND	ISNULL(isFree, 0)	= <cfqueryparam value="#local.filter.isFree#" cfsqltype="cf_sql_integer" />
					</cfif>
										
	            	<!---<cfif structKeyExists(local.filter, 'carrierId') and Len(local.filter.carrierId)>
	            		AND	CarrierId = <cfqueryparam value="#local.filter.carrierId#" cfsqltype="cf_sql_integer" />
	            	</cfif>--->
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
			
			<cfquery name="local.getAccessories" datasource="#application.dsn.wirelessadvocates#">
				SELECT * FROM catalog.dn_MasterAccessories                           
				WHERE ProductTypeId =	4
				<cfif StructKeyExists(local.filter, "isActive") and Len(local.filter.isActive)>
					AND	ISNULL(active, 0)	= <cfqueryparam value="#local.filter.isActive#" cfsqltype="cf_sql_integer" />
				</cfif>
 				<!--- Uncomment this once the isFree column has been added to catalog.dn_MasterAccessories --->			
 				<cfif StructKeyExists(local.filter, "isFree") and Len(local.filter.isFree)>
					AND	ISNULL(isFree, 0)	= <cfqueryparam value="#local.filter.isFree#" cfsqltype="cf_sql_integer" />
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
			<cfset qry = local.getAccessories /> 
			<cfquery name="local.getAccessories2" dbtype="query">
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
		<cfif structKeyExists(local,"getAccessories2")>
			<cfreturn local.getAccessories2 />
		<cfelse>
			<cfreturn local.getAccessories />
		</cfif>
	</cffunction>

	<cffunction name="getAccessoriesDropDown" returntype="query">
		<cfargument name="filter" type="struct" default="StructNew()" />
		<cfargument name="Manufacturer" required="no" default=""> <!--- TODO: implement carrier --->

		<cfset var local = { filter = arguments.filter } />

		<cfquery name="local.getAccessories" datasource="#application.dsn.wirelessadvocates#">

			SELECT DISTINCT
			      cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END AS 'Name',
			       a.AccessoryGuid
			FROM catalog.Accessory a
				INNER JOIN catalog.AccessoryForDevice afd ON afd.AccessoryGuid = a.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
			LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'
			WHERE cp.active = 1
			ORDER BY    cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END
		</cfquery>

		<cfreturn local.getAccessories />
	</cffunction>

	<cffunction name="getFreeAccessories" returntype="query" hint="data for drop down on ">
		<cfargument name="filter" type="struct" default="StructNew()" />
		<cfargument name="Manufacturer" required="no" default=""> <!--- TODO: implement carrier --->

		<cfset var local = { filter = arguments.filter } />

		<cfquery name="local.getAccessories" datasource="#application.dsn.wirelessadvocates#">
			SELECT cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END AS 'Name',
				a.AccessoryGuid
			FROM catalog.Accessory a
				INNER JOIN catalog.DeviceFreeAccessory dfa ON dfa.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
				LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'
			WHERE cp.Active = 1

			ORDER BY cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END

		</cfquery>

		<cfreturn local.getAccessories />
	</cffunction>

	<cffunction name="getFeaturedAccessories" returntype="query" hint="data for drop down on ">
		<cfargument name="filter" type="struct" default="StructNew()" />
		<cfargument name="Manufacturer" required="no" default=""> <!--- TODO: implement carrier --->

		<cfset var local = { filter = arguments.filter } />
		<!---This is just for dropdown in admin--->
		<cfquery name="local.getAccessories" datasource="#application.dsn.wirelessadvocates#">
			SELECT DISTINCT
			      cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END AS 'Name',
			       a.AccessoryGuid
			FROM catalog.Accessory a
				INNER JOIN catalog.AccessoryForDevice afd ON afd.AccessoryGuid = a.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
			LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'
			WHERE cp.active = 1
			ORDER BY    cgi.MinorCode + ' - ' + cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END
		</cfquery>
		<cfreturn local.getAccessories />
	</cffunction>


	<cffunction name="getAccessory" returntype="query">
		<cfargument name="accessoryId" required="true" />

		<cfset var local = { accessoryId = arguments.accessoryId } />

		<!--- query to pull accessories --->
		<cfquery name="local.getAccessory" datasource="#application.dsn.wirelessadvocates#">
			SELECT a.accessoryGuid,
				a.Name,
				a.UPC,
				a.ManufacturerGuid,
				IsNull(p.Active,0) as Active,
				IsNull(c.CompanyName,'') as Manufacturer,
				p.GERSSKU as GERSSKU,
				p.ProductId,
				IsNull((select value from catalog.Property where Name = 'Title' and ProductGuid = a.accessoryGuid),'') as Title,
				IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = a.accessoryGuid),'') as ShortDescription,
				IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = a.accessoryGuid),'') as LongDescription,
				IsNull((select value from catalog.Property where Name = 'MetaKeywords' and ProductGuid = a.accessoryGuid),'') as MetaKeywords,
				IsNull((select value from catalog.Property where Name = 'Inventory.HoldBackQty' and ProductGuid = a.accessoryGuid),'') as SafteyStock,
				ch.channelID,
				ch.channel
			FROM catalog.Accessory a
				JOIN catalog.ProductGuid pg
					ON pg.ProductGuid = a.accessoryGuid
				LEFT JOIN catalog.Company c
					ON c.CompanyGuid = a.ManufacturerGuid
				LEFT JOIN catalog.Product p
					ON p.ProductGuid = pg.ProductGuid
				LEFT JOIN catalog.channel ch
					ON ch.channelID = p.channelID
			WHERE a.AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />
		</cfquery>

		<cfreturn local.getAccessory>
	</cffunction>

	<cffunction name="insertAccessory" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				name = arguments.form.name,
				upc = arguments.form.upc,
				accessoryId = Insert("-", CreateUUID(), 23),
				manufacturerId = arguments.form.manufacturers,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				active = false,
				gersSku = arguments.form.gersSku,
				productTypeId = application.model.Utility.getProductTypeId("Accessory"),
				channelID = arguments.form.channelID,
				SafteyStock = arguments.form.SafteyStock
			} />

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.active = true />
		</cfif>

		<cfset application.model.AdminProductGuid.insertProductGuid(local.accessoryId, local.productTypeId) />
		<cfset application.model.AdminProduct.insertProduct(local.accessoryId, local.gersSku, local.active, local.channelID) />

		<cfquery name="local.insertAccessory" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO catalog.Accessory (
				AccessoryGuid,
				ManufacturerGuid,
				UPC,
				Name
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manufacturerId#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.upc#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.Name#" />
			)
		</cfquery>

		<!--- update the accessory properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "title", title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "shortDescription", shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "longDescription", longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "Inventory.HoldBackQty", local.SafteyStock, "Mac") /> <!--- TODO: update user --->
		<cfreturn local.accessoryId />
	</cffunction>

	<cffunction name="updateAccessory" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				name = arguments.form.name,
				accessoryId = arguments.form.accessoryId,
				upc = arguments.form.upc,
				manufacturerId = arguments.form.manufacturers,
				title = arguments.form.title,
				shortDescription = arguments.form.ShortDescription,
				longDescription = arguments.form.longDescription,
				active = false,
				gersSku = arguments.form.gersSku,
				channelId = arguments.form.channelID,
				SafteyStock = arguments.form.SafteyStock
			} />

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.active = true />
		</cfif>

		<!--- query to update product table --->
		<cfset application.model.AdminProduct.updateProduct(local.accessoryId, local.gersSku, local.active, local.channelID) />

		<cftry>
			<!--- updates accessory table --->
			<cfquery name="local.updateAccessory" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.Accessory
				SET
					<cfif local.manufacturerId neq "">
						ManufacturerGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.manufacturerId#" />,
					</cfif>
					UPC = <cfqueryparam cfsqltype="cf_sql_char" value="#local.upc#" />,
					Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.Name#" />
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- update the accessory properties --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "title", title,  "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "shortDescription", shortDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "longDescription", longDescription, "Mac") /> <!--- TODO: update user --->
		<cfset application.model.PropertyManager.setGenericProperty(local.accessoryId, "Inventory.HoldBackQty", local.SafteyStock, "Mac") /> <!--- TODO: update user --->

		<cfreturn "success" />
	</cffunction>

	<cffunction name="cloneAccessory" returntype="string">
		<cfargument name="deviceGuid" type="string" />
		<cfargument name="deviceUPC" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_Accessory" datasource="#application.dsn.wirelessadvocates#">
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

	<cffunction name="cloneMasterAccessory" returntype="string">
		<cfargument name="deviceGuid" type="string" />
		<cfargument name="name" type="string" />
		<cfargument name="newUPC" type="string" />
		<cfargument name="oldSKU" type="string" />
		<cfargument name="accessoryGersSku" type="string" default="">
		<cfargument name="channelId" type="numeric" />
		<cfargument name="active" type="numeric" />
		<cfargument name="productId" type="numeric" />

		<cfset var newProductGuid = "">

		<cfstoredproc procedure="clone.usp_MasterAccessory" datasource="#application.dsn.wirelessadvocates#">
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
	<cffunction name="getMasterAccessory" access="public" output="false" returntype="struct" hint="Returns the data for the Master Channel device pased on productID">
		<cfargument name="productId" type="any" required="true" />
		<cfset var masterData = "" />
		<cfset var local = structNew()>
		<cftry>
			<cfquery name="masterData" datasource="#application.dsn.wirelessadvocates#" >
				SELECT IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = a.accessoryGuid),'') ShortDescription
					, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = a.accessoryGuid),'') LongDescription
				FROM catalog.accessory a
					INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = a.AccessoryGuid
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
		<cfargument name="accessoryGuid" type="string" required="true" />
		<cfset var local = {} />
		<cfset local.query = '' />

		<cfquery name="local.query" datasource="#application.dsn.wirelessadvocates#" >
			SELECT channelId
			FROM catalog.product
			WHERE productGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accessoryGuid#">
		</cfquery>

		<cfset local.channelId = local.query.channelId />

		<cfreturn local.channelId />
	</cffunction>
</cfcomponent>