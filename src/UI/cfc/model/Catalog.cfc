<cfcomponent displayname="Catalog" output="false">

	<cffunction name="init" access="public" output="false" returntype="Catalog">
		<cfreturn this />
	</cffunction>

    <cffunction name="cloneDeviceAccessories" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
				originalProductGuid = arguments.originalProductGuid,
				newProductGuid = arguments.newProductGuid
			} />

		<!--- grab accessories for original product --->
		<cfset local.origDeviceAccessories = application.model.Catalog.getDeviceAccessories(local.originalProductGuid) />

		<cfloop query="local.origDeviceAccessories">
			<!--- insert accessories for new product --->
			<cfset insertAccessoryForDevice(local.origDeviceAccessories.AccessoryGuid, local.newProductGuid, local.origDeviceAccessories.Ordinal) />
		</cfloop>

	</cffunction>

    <cffunction name="cloneDeviceRateplans" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
				originalProductGuid = arguments.originalProductGuid,
				newProductGuid = arguments.newProductGuid
			} />

		<!--- grab accessories for original product --->
		<cfset local.origDevicePlans = getDeviceRateplans(local.originalProductGuid) />

		<cfloop query="local.origDevicePlans">
			<!--- insert accessories for new product --->
			<cfset insertDeviceRateplan(local.newProductGuid, local.origDevicePlans.RateplanGuid) />
		</cfloop>

	</cffunction>

    <cffunction name="cloneDeviceServices" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
				originalProductGuid = arguments.originalProductGuid,
				newProductGuid = arguments.newProductGuid
			} />

		<!--- grab services for original product --->
		<cfset local.origDeviceServices = getDeviceServices(local.originalProductGuid) />

		<cfloop query="local.origDeviceServices">
			<!--- insert services for new product --->
			<cfset insertDeviceService(local.newProductGuid, local.origDeviceServices.ServiceGuid) />
		</cfloop>
	</cffunction>

    <cffunction name="cloneRateplanServices" returntype="string">
		<cfargument name="originalProductGuid" type="string" />
		<cfargument name="newProductGuid" type="string" />

		<cfset var local = {
				originalProductGuid = arguments.originalProductGuid,
				newProductGuid = arguments.newProductGuid
			} />

		<!--- grab services for original product --->
		<cfset local.origDeviceServices = getDeviceServices(local.originalProductGuid) />

		<cfloop query="local.origDeviceServices">
			<!--- insert services for new product --->
			<cfset insertRateplanService(local.newProductGuid, local.origDevicePlans.RateplanGuid) />
		</cfloop>
	</cffunction>

    <cffunction name="cloneRateplanDevices" returntype="string">
		<cfargument name="originalRateplanGuid" type="string" />
		<cfargument name="newRateplanGuid" type="string" />

		<cfset var local = {
				originalRateplanGuid = arguments.originalRateplanGuid,
				newRateplanGuid = arguments.newRateplanGuid
			} />

		<!--- grab accessories for original product --->
		<cfset local.origPlanDevices = getRateplanDevices(local.originalRateplanGuid) />

		<cfloop query="local.origPlanDevices">
			<!--- insert accessories for new product --->
			<cfset insertDeviceRateplan(local.origPlanDevices.DeviceGuid, local.newRateplanGuid) />
		</cfloop>

	</cffunction>

	<cffunction name="getDeviceRateplans" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetDeviceRateplans" datasource="#application.dsn.wirelessAdvocates#">
				SELECT
					dp.*
					, prd.*
					, (SELECT TOP 1 IsDefaultRateplan FROM catalog.RateplanDevice rpd WHERE rpd.RateplanGuid = dp.RateplanGuid) IsDefaultRateplan
				FROM catalog.dn_Plans dp
				LEFT JOIN Catalog.Product prd ON (dp.RateplanGuid = prd.ProductGuid)
				WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanDevice rpd
					WHERE
						rpd.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
					AND	rpd.RateplanGuid = dp.RateplanGuid
				)
		</cfquery>

		<cfreturn local.qGetDeviceRateplans>
	</cffunction>

	<cffunction name="getDeviceServices" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>

<!---
		<cfquery name="local.qGetDeviceServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Service s
				<!--- TRV: we need this join to get a ProductId, but it appears the Product table isn't popualte with Services just yet --->
				left join catalog.Product prd
					on s.ServiceGuid = prd.ProductGuid
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.DeviceService ds
						inner join catalog.Device d
							on d.DeviceGuid = ds.DeviceGuid
					WHERE
						d.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
					AND	ds.ServiceGuid = s.ServiceGuid
				)
		</cfquery>
--->

		<cfquery name="local.qGetDeviceServices" datasource="#application.dsn.wirelessAdvocates#">
         SELECT *
		 FROM
   			catalog.Service s
   			left join catalog.Product prd
          	on s.ServiceGuid = prd.ProductGuid
			WHERE
			   EXISTS (
		          SELECT 1
		          FROM
		                 catalog.DeviceService ds
		                 inner join catalog.Device d
		                        on d.DeviceGuid = ds.DeviceGuid
		          WHERE
		                 d.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
		                 AND    ds.ServiceGuid = s.ServiceGuid
		       
		          UNION 
		       
		          SELECT 1
		          FROM
		                 catalog.DeviceService ds
		                 inner join catalog.tablet d
		                        on d.tabletGuid = ds.DeviceGuid
		          WHERE
		                 d.tabletguid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
		                 AND    ds.ServiceGuid = s.ServiceGuid
			   )
		</cfquery>



		<cfreturn local.qGetDeviceServices>
	</cffunction>

	<cffunction name="getDeviceRateplanServices" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfargument name="RateplanGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetDeviceRateplanServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Service s
				<!--- TRV: we need this join to get a ProductId, but it appears the Product table isn't popualte with Services just yet --->
				left join catalog.Product prd
					on s.ServiceGuid = prd.ProductGuid
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanService rps
						inner join catalog.Rateplan rp
							on rp.RateplanGuid = rps.RateplanGuid
					WHERE
						rp.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.RateplanGuid#">
					AND	rps.ServiceGuid = s.ServiceGuid
				)
			AND	EXISTS (
					SELECT 1
					FROM
						catalog.DeviceService ds
						inner join catalog.Device d
							on d.DeviceGuid = ds.DeviceGuid
					WHERE
						d.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
					AND	ds.ServiceGuid = s.ServiceGuid
				)
		</cfquery>

		<cfreturn local.qGetDeviceRateplanServices>
	</cffunction>

	<cffunction name="getDeviceServiceRateplans" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfargument name="ServiceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetDeviceServiceRateplans" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.dn_Plans dp
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanDevice rpd
						inner join catalog.Device d
							on d.DeviceGuid = rpd.DeviceGuid
					WHERE
						d.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
					AND	rpd.RateplanGuid = dp.RateplanGuid
				)
			AND	EXISTS (
					SELECT 1
					FROM
						catalog.RateplanService rps
						inner join catalog.Service s
							on s.ServiceGuid = rps.ServiceGuid
					WHERE
						s.ServiceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.ServiceGuid#">
					AND	rps.RateplanGuid = dp.RateplanGuid
				)
		</cfquery>

		<cfreturn local.qGetDeviceServiceRateplans>
	</cffunction>

	<cffunction name="getDeviceAccessory" access="public" output="false" returntype="query">
		<cfargument name="AccessoryGuid" type="string" required="true">
		<cfargument name="DeviceGuid" type="string" required="true">

		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId
			} />

		<cfquery name="local.qGetDeviceAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Accessory a
				inner join catalog.AccessoryForDevice afd
					ON	a.AccessoryGuid = afd.AccessoryGuid
					AND	afd.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
				left join catalog.Product prd
					on a.AccessoryGuid = prd.ProductGuid
			WHERE afd.AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.AccessoryGuid#" /> AND
				  afd.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.DeviceGuid#" />
		</cfquery>

		<cfreturn local.qGetDeviceAccessories>
	</cffunction>

	<cffunction name="getDeviceAccessories" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>


		<cfquery name="local.qGetDeviceAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	cgi.MinorCode AS 'Type',
					ISNULL(cpy.Value,a.Name) AS 'Name',
					cp.Active,
					(
						SELECT Channel
						FROM catalog.Channel
						WHERE ChannelID = cp.ChannelID
					) AS 'Channel',
					ci.binImage AS 'Image',
					a.upc,
					a.accessoryGuid,
					cp.GersSku
			FROM catalog.Accessory a
				INNER JOIN catalog.AccessoryForDevice afd ON afd.AccessoryGuid = a.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
				LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'
				LEFT JOIN catalog.Image ci ON ci.ReferenceGuid = a.AccessoryGuid
			WHERE afd.DeviceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.DeviceGuid#">
			ORDER BY cp.Active DESC

		</cfquery>

		<cfreturn local.qGetDeviceAccessories>
	</cffunction>

	<cffunction name="getFreeDeviceAccessories" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetFreeDeviceAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	cgi.MinorCode AS 'Type',
					ISNULL(cpy.Value,a.Name) AS 'Name',
					cp.Active,
					(
						SELECT Channel
						FROM catalog.Channel
						WHERE ChannelID = cp.ChannelID
					) AS 'Channel',
					ci.binImage AS 'Image',
					a.upc,
					a.accessoryGuid,
					cp.GersSku
			FROM catalog.Accessory a
				INNER JOIN catalog.DeviceFreeAccessory dfa ON dfa.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
				LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'
				LEFT JOIN catalog.Image ci ON ci.ReferenceGuid = a.AccessoryGuid
			WHERE dfa.DeviceGuid = <cfqueryparam value="#DeviceGuid#" cfsqltype="cf_sql_varchar" />
			ORDER BY cp.Active DESC
		</cfquery>

		<cfreturn local.qGetFreeDeviceAccessories>
	</cffunction>

	<!---This is the query to return Featured Accessories for one device. This should be used on front end and admin area for sorting accessories section---->
	<cffunction name="getFeaturedDeviceAccessories" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetFeaturedDeviceAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	a.ProductId, a.AccessoryGuid, a.summaryTitle, a.summaryDescription, a.price_retail, cgi.MinorCode AS 'Type',
					ISNULL(cpy.Value,ab.Name) AS 'Name',
					cp.Active,					
					ab.upc,
					cp.GersSku
			FROM catalog.dn_Accessories AS a WITH (NOLOCK)
			INNER JOIN catalog.Accessory ab ON a.AccessoryGuid = ab.AccessoryGuid
				INNER JOIN catalog.FeaturedAccessoryForDevice fa ON fa.AccessoryGuid = ab.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = a.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
				LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.AccessoryGuid AND cpy.Name = 'Title'				
			WHERE fa.DeviceGuid = <cfqueryparam value="#DeviceGuid#" cfsqltype="cf_sql_varchar" />
			ORDER BY fa.ordinal ASC, cp.Active DESC
		</cfquery>

		<cfreturn local.qGetFeaturedDeviceAccessories>
	</cffunction>
	<!---This is the query to return Featured Accessories in admin. It is the same query as GetFeaturedDeviceAccessories just does not use dn_accessories---->
	<cffunction name="getFeaturedDeviceAccessoriesAdmin" access="public" output="false" returntype="query">
		<cfargument name="DeviceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetFeaturedDeviceAccessories" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	ISNULL(cpy.Value,ab.Name) AS 'Name',
					cp.Active,					
					ab.upc,
					cp.GersSku, ab.AccessoryGuid
			FROM catalog.Accessory ab 
				INNER JOIN catalog.FeaturedAccessoryForDevice fa ON fa.AccessoryGuid = ab.AccessoryGuid
				INNER JOIN catalog.Product cp ON cp.ProductGuid = ab.AccessoryGuid
				INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
				LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = ab.AccessoryGuid AND cpy.Name = 'Title'				
			WHERE fa.DeviceGuid = <cfqueryparam value="#DeviceGuid#" cfsqltype="cf_sql_varchar" />
			ORDER BY fa.ordinal ASC, cp.Active DESC
		</cfquery>

		<cfreturn local.qGetFeaturedDeviceAccessories>
	</cffunction>
	<cffunction name="getRateplanDevices" access="public" output="false" returntype="query">
		<cfargument name="RateplanGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cftry>
			<cfquery name="local.qGetRateplanDevices" datasource="#application.dsn.wirelessAdvocates#">
				SELECT
					*
				FROM
					catalog.dn_Phones dp
				LEFT JOIN Catalog.Product prd
					ON (dp.DeviceGuid = prd.ProductGuid)
				WHERE
					EXISTS (
						SELECT 1
						FROM
							catalog.RateplanDevice rpd
						WHERE
							rpd.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.RateplanGuid#">
						AND	rpd.DeviceGuid = dp.DeviceGuid
					)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.qGetRateplanDevices>
	</cffunction>

	<cffunction name="getRateplanServices" access="public" output="false" returntype="query">
		<cfargument name="RateplanGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetRateplanServices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Service s
				<!--- TRV: we need this join to get a ProductId, but it appears the Product table isn't popualte with Services just yet --->
				left join catalog.Product prd
					on s.ServiceGuid = prd.ProductGuid
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanService rps
						inner join catalog.Rateplan rp
							on rp.RateplanGuid = rps.RateplanGuid
					WHERE
						rp.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.RateplanGuid#">
					AND	rps.ServiceGuid = s.ServiceGuid
				)
		</cfquery>

		<cfreturn local.qGetRateplanServices>
	</cffunction>

	<cffunction name="getRateplanServiceDevices" access="public" output="false" returntype="query">
		<cfargument name="RateplanGuid" type="string" required="true">
		<cfargument name="ServiceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetRateplanServiceDevices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.dn_Phones dp
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanDevice rpd
						inner join catalog.Rateplan rp
							on rp.RateplanGuid = rpd.RateplanGuid
					WHERE
						rp.RateplanGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.RateplanGuid#">
					AND	rpd.DeviceGuid = dp.DeviceGuid
				)
			AND	EXISTS (
					SELECT 1
					FROM
						catalog.DeviceService ds
						inner join catalog.Service s
							on s.ServiceGuid = ds.ServiceGuid
					WHERE
						s.ServiceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.ServiceGuid#">
					AND	ds.DeviceGuid = dp.DeviceGuid
				)
		</cfquery>

		<cfreturn local.qGetRateplanServiceDevices>
	</cffunction>

	<cffunction name="getServiceRateplans" access="public" output="false" returntype="query">
		<cfargument name="ServiceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetServiceRateplans" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.Rateplan r
				left join catalog.Product prd
					on r.RateplanGuid = prd.ProductGuid
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.RateplanService rps
						inner join catalog.Service s
							on s.ServiceGuid = rps.ServiceGuid
					WHERE
						s.ServiceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.ServiceGuid#">
					AND	rps.RateplanGuid = r.RateplanGuid
				)
		</cfquery>

		<cfreturn local.qGetServiceRateplans>
	</cffunction>

	<cffunction name="getServiceDevices" access="public" output="false" returntype="query">
		<cfargument name="ServiceGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetServiceDevices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.dn_Phones dp
			WHERE
				EXISTS (
					SELECT 1
					FROM
						catalog.DeviceService ds
						inner join catalog.Service s
							on s.ServiceGuid = ds.ServiceGuid
					WHERE
						s.ServiceGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.ServiceGuid#">
					AND	ds.DeviceGuid = dp.DeviceGuid
				)
		</cfquery>

		<cfreturn local.qGetServiceDevices>
	</cffunction>

	<cffunction name="getAccessoryDevices" access="public" output="false" returntype="query">
		<cfargument name="AccessoryGuid" type="string" required="true">
		<cfset var local = structNew()>

		<cfquery name="local.qGetAccessoryDevices" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				*
			FROM
				catalog.dn_Phones dp
				inner join catalog.AccessoryForDevice afd
					ON	dp.DeviceGuid = afd.DeviceGuid
					AND	afd.AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_string" value="#arguments.AccessoryGuid#">
		</cfquery>

		<cfreturn local.qGetAccessoryDevices>
	</cffunction>

	<cffunction name="insertDeviceRateplan" returntype="string">
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="planId" type="string" required="true" />

 		<cfset var local = {
				planId = arguments.planId,
				deviceId = arguments.deviceId
			} />

		<cftry>
			<cfquery name="local.insertDeviceRateplan" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.RateplanDevice (
					RateplanGuid,
					DeviceGuid
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="insertDeviceService" returntype="string">
		<cfargument name="deviceGuid" type="string" required="true" />
		<cfargument name="serviceGuid" type="string" required="true" />

 		<cfset var local = {
				serviceGuid = arguments.serviceGuid,
				deviceGuid = arguments.deviceGuid
			} />

		<cftry>
			<cfquery name="local.insertDeviceService" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.DeviceService (
					DeviceGuid,
					ServiceGuid
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="insertRateplanService" returntype="string">
		<cfargument name="rateplanGuid" type="string" required="true" />
		<cfargument name="serviceGuid" type="string" required="true" />
		<cfargument name="IsIncludedd" type="Boolean" required="true" />
		<cfargument name="IsRequired" type="Boolean" required="true" />
		<cfargument name="IsDefault" type="Boolean" required="true" />

 		<cfset var local = {
				serviceGuid = arguments.serviceGuid,
				rateplanGuid = arguments.rateplanGuid,
				IsIncluded = arguments.IsIncluded,
				IsRequired = arguments.IsRequired,
				IsDefault = arguments.IsDefault
			} />

		<cftry>
			<cfquery name="local.insertRateplanService" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.RateplanService (
					ServiceGuid,
					RateplanGuid,
					IsIncluded,
					IsRequired,
					IsDefault
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.rateplanGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.IsIncluded#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.IsRequired#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.IsDefault#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="insertAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="ordinal" type="Numeric" default="0" />

 		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId,
				ordinal = arguments.ordinal
			} />

		<cftry>
			<cfquery name="local.insertAccessory" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO catalog.AccessoryForDevice (
					AccessoryGuid,
					DeviceGuid,
					Ordinal
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="updateAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="ordinal" type="Numeric" default="0" />

 		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId,
				ordinal = arguments.ordinal
			} />

		<cftry>
			<!--- updates accessory table --->
			<cfquery name="local.updateAccessoryForDevice" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE catalog.AccessoryForDevice
				SET Ordinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#" />
	           	WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
				<cfabort>
			</cfcatch>
		</cftry>

		<cfreturn "success" />
	</cffunction>

	<cffunction name="deleteAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId
			} />

		<!--- query to remove device-accessory relationship set in accessoryForDevice table --->
		<cftry>
	        <cfquery name="local.deleteAccessoryForDevice" datasource="#application.dsn.wirelessAdvocates#">
	        	DELETE FROM Catalog.AccessoryForDevice
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="insertFeaturedAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="ordinal" type="Numeric" default="0" />

 		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId,
				ordinal = arguments.ordinal
			} />

		<cftry>
			
			<cfquery name="local.findFeaturedAccessory" datasource="#application.dsn.wirelessAdvocates#">
				SELECT accessoryguid 
				FROM catalog.FeaturedAccessoryForDevice 
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />
				AND DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
			</cfquery>
			
			<cfif local.findFeaturedAccessory.recordCount EQ 0>
			
				<cfquery name="local.insertFeaturedAccessory" datasource="#application.dsn.wirelessAdvocates#">
					INSERT INTO catalog.FeaturedAccessoryForDevice (
						AccessoryGuid,
						DeviceGuid,
						Ordinal
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#" />
					)
				</cfquery>
			</cfif>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<!--- TODO: return more meaningful messages --->
		<cfreturn "success" />
	</cffunction>

	<cffunction name="updateFeaturedAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="ordinal" type="Numeric" default="0" />

 		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId,
				ordinal = arguments.ordinal
			} />

		<cftry>
			<!--- updates accessory table --->
			<cfquery name="local.updateFeaturedAccessoryForDevice" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE catalog.FeaturedAccessoryForDevice
				SET Ordinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#" />
	           	WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
				<cfabort>
			</cfcatch>
		</cftry>

		<cfreturn "success" />
	</cffunction>

	<cffunction name="deleteFeaturedAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId
			} />

		<!--- query to remove device-accessory relationship set in accessoryForDevice table --->
		<cftry>
	        <cfquery name="local.deleteFeaturedAccessoryForDevice" datasource="#application.dsn.wirelessAdvocates#">
	        	DELETE FROM Catalog.FeaturedAccessoryForDevice
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

	</cffunction>


	<!--- Modified on 01/06/2015 by Denard Springle (denard.springle@gmail.com) --->
	<!--- Track #: 7084 - Orders: Deprecate dbo.OldProdToNewProd table and remove dependent code [ Deprecate getNewProductIdFromOldProductId function ] --->
	<!---
	<cffunction name="getNewProductIdFromOldProductId" access="public" output="false" returntype="numeric">
		<cfargument name="OldProductId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.id = arguments.OldProductId>
		<cfquery name="local.qNewProductId" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				NewProductId
			FROM
				dbo.OldProdToNewProd
			WHERE
				OldProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OldProductId#">
		</cfquery>
		<cfif local.qNewProductId.recordCount>
			<cfset local.id = local.qNewProductId.NewProductId>
		</cfif>
		<cfreturn local.id>
	</cffunction>
	--->
	<!--- END EDITS on 01/06/2015 by Denard Springle --->

	<cffunction name="getDeviceRelatedAccessories" access="public" returntype="query" output="false">
		<cfargument name="productId" required="true" type="numeric" />

		<cfset var getDeviceRelatedAccessoriesReturn = '' />
		<cfset var qry_getDeviceRelatedAccessories = '' />

		<cfquery name="qry_getDeviceRelatedAccessories" datasource="#application.dsn.wirelessadvocates#">
			SELECT		a.ProductId, a.AccessoryGuid, a.summaryTitle, a.summaryDescription, a.price_retail
			FROM		catalog.dn_Accessories AS a WITH (NOLOCK)
			INNER JOIN	catalog.AccessoryForDevice AS afd WITH (NOLOCK) ON afd.AccessoryGuid = a.AccessoryGuid
			INNER JOIN	catalog.Product AS p WITH (NOLOCK) ON p.ProductGuid = afd.DeviceGuid
			WHERE		p.ProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer" />
				AND		ISNULL(a.QtyOnHand, 0) > 0
				AND 	a.price_retail > 0
				ORDER BY categoryName, defaultSortRank
			<!---ORDER BY	a.price_retail DESC, a.summaryTitle--->
		</cfquery>

		<cfset getDeviceRelatedAccessoriesReturn = qry_getDeviceRelatedAccessories />
		<cfreturn getDeviceRelatedAccessoriesReturn />
	</cffunction>


	<cffunction name="getAccessoryRelatedDevices" access="public" returntype="query" output="false">
		<cfargument name="productId" required="true" type="numeric" />

		<cfset var qDevices = '' />

		<cfquery name="qDevices" datasource="#application.dsn.wirelessadvocates#">
			SELECT
				d.CarrierId
				, d.ProductId
				, d.DeviceGuid
				, d.GersSku
				, d.summaryTitle
				, d.summaryDescription
				, d.price_retail
				, (SELECT TOP 1 i.ImageGuid FROM catalog.Image i WITH (NOLOCK) WHERE i.ReferenceGuid = d.ProductGuid AND i.IsPrimaryImage = 1) ImageGuid
			FROM catalog.dn_Phones AS d WITH (NOLOCK)
			WHERE
				EXISTS (
					SELECT 1
					FROM catalog.AccessoryForDevice AS afd WITH (NOLOCK)
					INNER JOIN catalog.Product AS p WITH (NOLOCK) ON p.ProductGuid = afd.AccessoryGuid
					WHERE
						p.ProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer" />
						AND afd.DeviceGuid = d.ProductGuid
				)
				AND ISNULL(d.QtyOnHand, 0) > 0
			ORDER BY
				d.price_retail DESC
				, d.summaryTitle
		</cfquery>

		<cfreturn qDevices />
	</cffunction>
</cfcomponent>