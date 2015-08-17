<cfcomponent output="false" displayname="AdminDevicePlan">

	<cffunction name="init" returntype="AdminDevicePlan">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getDevicePlan" returntype="query">
		<cfargument name="planGuid" type="string" />
		<cfargument name="deviceGuid" type="string" />

		<cfset var local = {
				planGuid = arguments.planGuid,
				deviceGuid = arguments.deviceGuid
			} />

		<cftry>
			<cfquery name="local.getDevicePlan" datasource="#application.dsn.wirelessadvocates#">
				SELECT RatePlanGuid,
					   DeviceGuid
				FROM catalog.RatePlanDevice
				WHERE RatePlanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getDevicePlan />
	</cffunction>

	<cffunction name="getPlansList" returntype="query">
    	<cfargument name="filter" type="struct" default="StructNew()" />

		<cfset var local = {
				filter = arguments.filter
			 } />

		<cftry>
	        <cfquery name="local.getPlans" datasource="#application.dsn.wirelessadvocates#">
				SELECT DISTINCT r.CarrierBillCode + ' - ' + CASE WHEN ISNULL(cpy.Value,r.Title) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,r.Title) END AS 'Name',
					r.ratePlanGuid
				FROM catalog.rateplan r
					INNER JOIN catalog.rateplandevice afd ON afd.rateplanguid = r.rateplanguid
					INNER JOIN catalog.Product cp ON cp.ProductGuid = r.rateplanguid
					INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
					LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = r.rateplanguid AND cpy.Name = 'Title'
				WHERE cp.Active = 1
					AND CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.carrierGuid#" />
					<cfif structKeyExists(local.filter, "notDevice")>
						AND afd.DeviceGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.notDevice#" />
						OR afd.DeviceGuid IS NULL
					</cfif>
				ORDER BY r.CarrierBillCode + ' - ' + CASE WHEN ISNULL(cpy.Value,r.Title) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,r.Title) END DESC
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getPlans />
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

	<cffunction name="insertDevicePlan" returntype="string">
		<cfargument name="form" type="struct" />

		<cfset var local = {
				deviceGuid = arguments.form.deviceGuid,
				planGuid = arguments.form.planGuid
			} />

		<cftry>
			<cfquery name="local.insertRatePlanDevice" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO catalog.RatePlanDevice (
					DeviceGuid,
					RatePlanGuid
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_" value="#local.deviceGuid#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planGuid#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn "success" />
	</cffunction>

	<cffunction name="deleteDevicePlan" returntype="string">
		<cfargument name="planGuid" type="string" />
		<cfargument name="deviceGuid" type="string" />

		<cfset var local = {
				deviceGuid = arguments.deviceGuid,
				planGuid = arguments.planGuid
			} />

		<cftry>
			<cfquery name="local.deleteDeviceService" datasource="#application.dsn.wirelessadvocates#">
				DELETE FROM catalog.RatePlanDevice
				WHERE DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceGuid#" /> AND
					  RatePlanGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.planGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>