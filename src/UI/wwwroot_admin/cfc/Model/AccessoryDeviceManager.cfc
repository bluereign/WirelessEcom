<cfcomponent output="false" displayname="AccessoryDeviceManager">

	<cffunction name="init" returntype="AccessoryDeviceManager">
    	<cfreturn this />
    </cffunction>

	<cffunction name="bulkAccessoryDeviceUpdate" access="public" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				message = "",
				accessoryId = arguments.form.accessoryId,
				orderList = arguments.form.order
			} />

		<!--- set the display order, active, and default display of images --->
		<cfset local.orderCounter = 1 />
		<cfloop list="#local.orderList#" index="local.orderDevice">
			<cfset updateAccessoryDevice(local.orderDevice, local.accessoryId, local.orderCounter) />
			<cfset local.orderCounter += 1 />
		</cfloop>

		<cfset local.message = "Success" />
		<cfreturn local.message />
	</cffunction>

	<cffunction name="deleteAccessoryDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cftry>
	        <cfquery name="local.deleteAccessoryForDevice" datasource="#application.dsn.wirelessadvocates#">
	        	DELETE FROM Catalog.AccessoryForDevice
				WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceId#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

	</cffunction>

    <cffunction name="getAccessoryForDevice" returntype="query">
    	<cfargument name="accessoryId" type="string" required="true" />
    	<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
				accessoryId = arguments.accessoryId,
				deviceId = arguments.deviceId
			} />

        <!--- query to pull accessories --->
		<cftry>
	        <cfquery name="local.getAccessoryForDevice" datasource="#application.dsn.wirelessadvocates#">
	        	SELECT AccessoryGuid,
					   DeviceGuid,
					   Ordinal
	            FROM catalog.AccessoryForDevice
	           	WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getAccessoryForDevice />
    </cffunction>

	<cffunction name="getPhonesList" returntype="query">
    	<cfargument name="filter" type="struct" default="StructNew()" />

		<cfset var local = {
				filter = arguments.filter
			 } />

		<cftry>
	        <cfquery name="local.getPhones" datasource="#application.dsn.wirelessadvocates#">
				SELECT DISTINCT cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END AS 'Name',
					a.deviceGuid
				FROM catalog.device a
					INNER JOIN catalog.AccessoryForDevice dfa ON dfa.DeviceGuid = a.DeviceGuid
					INNER JOIN catalog.Product cp ON cp.ProductGuid = a.DeviceGuid
					LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = a.DeviceGuid AND cpy.Name = 'Title'

				WHERE cp.active=1

				ORDER BY cp.GersSku + ' - ' + CASE WHEN ISNULL(cpy.Value,a.Name) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,a.Name) END
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getPhones />
    </cffunction>

    <cffunction name="getAccessoriesNotForDevice" returntype="query">
    	<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
				deviceId = arguments.deviceId
			} />

		<cftry>
	       	<cfquery name="local.getAccessoriesNotForDevice" datasource="#application.dsn.wirelessadvocates#">
	        	SELECT ad.AccessoryGuid,
	        		   a.Name AS AccessoryName
	            FROM catalog.Accessory a
	            JOIN catalog.AccessoryForDevice ad
	            	ON (a.AccessoryGuid = ad.AccessoryGuid)
	           	WHERE DeviceGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getAccessoriesNotForDevice />
    </cffunction>

    <cffunction name="getAccessoriesForDevice" returntype="query">
    	<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
				deviceId = arguments.deviceId
			} />

		<cftry>
	       	<cfquery name="local.getAccessoriesForDevice" datasource="#application.dsn.wirelessadvocates#">
	        	SELECT ad.AccessoryGuid,
	        		   a.Name AS Name,
					   DeviceGuid,
					   Ordinal
	            FROM catalog.AccessoryForDevice ad
	            JOIN catalog.Accessory a
	            	ON (ad.AccessoryGuid = a.AccessoryGuid)
	           	WHERE DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
	           	ORDER BY Ordinal
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getAccessoriesForDevice />
    </cffunction>

    <cffunction name="getDevicesForAccessory" returntype="query">
    	<cfargument name="AccessoryId" type="string" required="true" />

		<cftry>
	       	<cfquery name="local.getAccessoriesForDevice" datasource="#application.dsn.wirelessadvocates#">
				SELECT ad.AccessoryGuid,
					   d.Name AS Name,
					   d.DeviceGuid,
					   ad.Ordinal

				FROM catalog.AccessoryForDevice ad
					INNER JOIN catalog.Device d ON (ad.DeviceGuid = d.DeviceGuid)
				WHERE ad.AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AccessoryId#" />

				UNION

				SELECT ad.DeviceFreeAccessoryGuid as AccessoryGuid,
					   d.Name AS Name,
					   d.DeviceGuid,
					   '1' as Ordinal
				FROM catalog.DeviceFreeAccessory ad
					INNER JOIN catalog.Device d ON (ad.DeviceGuid = d.DeviceGuid)
				WHERE ad.DeviceFreeAccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AccessoryId#" />

				ORDER BY Ordinal
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getAccessoriesForDevice />
    </cffunction>

	<cffunction name="insertAccessoryForDevice" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />
		<cfargument name="deviceId" type="string" required="true" />
		<cfargument name="ordinal" type="Numeric" default="0" />

		<cftry>
			<cfquery name="insertAccessory" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.AccessoryForDevice (
					AccessoryGuid,
					DeviceGuid,
					Ordinal
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accessoryId#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceId#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ordinal#" />
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
			<cfquery name="local.updateAccessoryForDevice" datasource="#application.dsn.wirelessadvocates#">
				UPDATE catalog.AccessoryForDevice
				SET Ordinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.ordinal#" />
	           	WHERE AccessoryGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.accessoryId#" /> AND
					  DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn "success" />
	</cffunction>

</cfcomponent>