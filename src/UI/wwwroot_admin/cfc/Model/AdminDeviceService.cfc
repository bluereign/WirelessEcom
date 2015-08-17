<cfcomponent output="false" displayname="AdminDeviceService">

	<cffunction name="init" returntype="AdminDeviceService">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getDeviceService" returntype="query">
		<cfargument name="serviceGuid" type="string" />
		<cfargument name="deviceGuid" type="string" />

		<cfset var local = {
				serviceGuid = arguments.serviceGuid,
				deviceGuid = arguments.deviceGuid
			} />

		<cftry>
			<cfquery name="local.getDeviceService" datasource="#application.dsn.wirelessadvocates#">
				SELECT ServiceGuid,
					   DeviceGuid
				FROM catalog.DeviceService
				WHERE serviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

		<cfreturn local.getDeviceService />
	</cffunction>

	<cffunction name="getServicesList" returntype="query">
    	<cfargument name="filter" type="struct" default="StructNew()" />

		<cfset var local = {
				filter = arguments.filter
			 } />

		<cftry>
	        <cfquery name="local.getServices" datasource="#application.dsn.wirelessadvocates#">
				SELECT DISTINCT
					s.CarrierBillCode + ' - ' + CASE WHEN ISNULL(cpy.Value,s.Title) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,s.Title) END AS 'Name',
					s.ServiceGuid
				FROM catalog.service s
					INNER JOIN catalog.rateplanservice afd ON afd.ServiceGuid = s.ServiceGuid
					INNER JOIN catalog.Product cp ON cp.ProductGuid = s.serviceguid
					INNER JOIN catalog.GersItm cgi ON cgi.GersSku = cp.GersSku
					LEFT JOIN catalog.Property cpy ON cpy.ProductGuid = s.serviceguid AND cpy.Name = 'Title'
				WHERE cp.Active = 1
					AND CarrierGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.carrierGuid#" />

				ORDER BY s.CarrierBillCode + ' - ' + CASE WHEN ISNULL(cpy.Value,s.Title) = '' THEN cp.GersSku ELSE ISNULL(cpy.Value,s.Title) END DESC


				<!---select distinct
					s.ServiceGuid,
					s.CarrierGuid,
					s.CarrierBillCode,
					s.Title as Name,
					IsNull(p.Active,0) as Active,
					ch.channelID,
                    ch.channel
				from
					catalog.Service s
				left join
					catalog.DeviceService ds
						on s.ServiceGuid = ds.ServiceGuid
				left join
					catalog.Product p
						on s.serviceGuid = p.ProductGuid
				LEFT JOIN catalog.channel ch
					ON ch.channelID = p.channelID
				where p.Active = 1
					AND CarrierGuid = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.carrierGuid#" />)
					<cfif structKeyExists(local.filter, "notDevice")>
						AND ds.DeviceGuid <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.filter.notDevice#" /> OR ds.DeviceGuid IS NULL
					</cfif>
				order by
				    s.Title--->
	        </cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>

        <cfreturn local.getServices />
    </cffunction>

	<cffunction name="insertDeviceService" returntype="string">
		<cfargument name="form" type="struct" />

		<cfset var local = {
				deviceGuid = arguments.form.deviceGuid,
				serviceGuid = arguments.form.serviceGuid
			} />

		<cftry>
			<cfquery name="local.insertDeviceService" datasource="#application.dsn.wirelessadvocates#">
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

		<cfreturn "success" />
	</cffunction>

	<cffunction name="deleteDeviceService" returntype="string">
		<cfargument name="serviceGuid" type="string" />
		<cfargument name="deviceGuid" type="string" />

		<cfset var local = {
				deviceGuid = arguments.deviceGuid,
				serviceGuid = arguments.serviceGuid
			} />

		<cftry>
			<cfquery name="local.deleteDeviceService" datasource="#application.dsn.wirelessadvocates#">
				DELETE FROM catalog.DeviceService
				WHERE DeviceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.deviceGuid#" /> AND
					  ServiceGuid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.serviceGuid#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>