<cfcomponent output="false" displayname="MyAccount">

	<cffunction name="init" access="public" returntype="cfc.model.MyAccount" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="getOrderHistory" access="public" output="false" returntype="cfc.model.Order[]">
		<cfargument name="userId" type="numeric" required="true" />

		<cfset var local = structNew() />

		<cfset local.o = createObject('component', 'cfc.model.Order').init() />
		<cfset local.a = local.o.getOrderHistoryByUserId(userId = arguments.userId, recursive = false) />

		<cfreturn local.a />
	</cffunction>

	<cffunction name="getShipmentTrackingNumber" access="public" returntype="query" output="false">
		<cfargument name="orderId" required="true" type="numeric" />

		<cfset var getShipmentTrackingNumberReturn = '' />
		<cfset var qry_getShipmentTrackingNumber = '' />

		<cfquery name="qry_getShipmentTrackingNumber" datasource="#application.dsn.wirelessAdvocates#">
			SELECT TOP 1	s.TrackingNumber
			FROM			salesorder.Shipment AS s WITH (NOLOCK)
			INNER JOIN		salesorder.OrderDetail AS od WITH (NOLOCK) ON od.ShipmentId = s.ShipmentId
			WHERE			od.OrderId = <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfset getShipmentTrackingNumberReturn = qry_getShipmentTrackingNumber />

		<cfreturn getShipmentTrackingNumberReturn />
	</cffunction>
</cfcomponent>