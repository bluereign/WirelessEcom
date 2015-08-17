<cfcomponent displayname="Shipment" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("ShipmentId|ShipMethod|TrackingNumber|DeliveryStatus", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.Shipment" output="false">
		<cfargument name="ShipmentId" type="numeric" required="false" default="0" />
		<cfargument name="ShipMethod" type="cfc.model.ShipMethod" required="false" default="#createObject('component','cfc.model.ShipMethod').init()#" />
		<cfargument name="TrackingNumber" type="string" required="false" default="" />
		<cfargument name="DeliveryStatus" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />

		<!--- run setters --->
		<cfset setShipmentId(arguments.ShipmentId) />
		<cfset setShipMethod(arguments.ShipMethod) />
		<cfset setTrackingNumber(arguments.TrackingNumber) />
		<cfset setDeliveryStatus(arguments.DeliveryStatus) />

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="setMemento" access="public" returntype="cfc.model.Shipment" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions"
	>
		<cfargument name="data" type="struct" required="true" />
		<cfset var i = "" />

		<cftry>
			<cfloop from="1" to="#arrayLen(variables.beanFieldArr)#" index="i">
				<cfif StructKeyExists(arguments.data, variables.beanFieldArr[i])>
					<cfinvoke method="set#variables.beanFieldArr[i]#">
						<cfinvokeargument name="#variables.beanFieldArr[i]#" value="#arguments.data[variables.beanFieldArr[i]]#" />
					</cfinvoke>
				</cfif>
			</cfloop>
			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="validate" access="public" returntype="errorHandler" output="false">
	</cffunction>

	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true">
		<cfif dateFormat(arguments.date,"mmddyyyy") eq dateFormat(variables.nullDateTime,"mmddyyyy")>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ShipmentId
			,	ShipMethodId
			,	TrackingNumber
			,	DeliveryStatus
			FROM
				SalesOrder.Shipment
			WHERE
				ShipmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.ShipmentId))) this.setShipmentId(local.qLoad.ShipmentId);
				if (len(trim(local.qLoad.ShipMethodId))) this.getShipMethod().load(local.qLoad.ShipMethodId);
				if (len(trim(local.qLoad.TrackingNumber))) this.setTrackingNumber(local.qLoad.TrackingNumber);
				if (len(trim(local.qLoad.DeliveryStatus))) this.setDeliveryStatus(local.qLoad.DeliveryStatus);
			}
			else
			{
				this = createObject("component","cfc.model.Shipment").init();
			}
		</cfscript>

		<cfset this.setIsDirty(false)>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<cfif not this.getShipmentId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO SalesOrder.Shipment (
					ShipMethodId
				,	TrackingNumber
				,	DeliveryStatus
				) VALUES (
					<cfif len(trim(this.getShipMethod().getShipMethodId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipMethod().getShipMethodId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getTrackingNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getTrackingNumber()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getDeliveryStatus()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDeliveryStatus()#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfset this.setShipmentId(local.saveResult.identitycol)>
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE SalesOrder.Shipment SET
					ShipMethodId = <cfif len(trim(this.getShipMethod().getShipMethodId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipMethod().getShipMethodId()#"><cfelse>NULL</cfif>
				,	TrackingNumber = <cfif len(trim(this.getTrackingNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getTrackingNumber()#"><cfelse>NULL</cfif>
				,	DeliveryStatus = <cfif len(trim(this.getDeliveryStatus()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDeliveryStatus()#"><cfelse>NULL</cfif>
				WHERE
					ShipmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipmentId()#">
			</cfquery>
		</cfif>

		<cfset this.load(this.getShipmentId())>
	</cffunction>

	<cffunction name="getDeliveryDate" access="public" returntype="any" output="false">
		<cfargument name="orderDate" required="false" type="date" default="#now()#" />
		<cfargument name="isOvernightShipping" required="false" type="boolean" default="0" />

		<cfset var getDeliveryDateReturn = '' />
		<cfset var qry_getDeliveryDate = '' />

		<cfquery name="qry_getDeliveryDate" datasource="#application.dsn.wirelessAdvocates#">
			SELECT salesorder.GetDeliveryDateFromOrderDate(#arguments.orderDate#, #arguments.isOvernightShipping#) AS DeliveryDate
		</cfquery>

		<cfset getDeliveryDateReturn = qry_getDeliveryDate.deliveryDate />

		<cfreturn getDeliveryDateReturn />
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setShipmentId" access="public" returntype="void" output="false">
		<cfargument name="ShipmentId" type="numeric" required="true" />
		<cfset variables.instance.ShipmentId = trim(arguments.ShipmentId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipmentId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ShipmentId />
	</cffunction>

	<cffunction name="setShipMethod" access="public" returntype="void" output="false">
		<cfargument name="ShipMethod" type="cfc.model.ShipMethod" required="true" />
		<cfset variables.instance.ShipMethod = arguments.ShipMethod />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipMethod" access="public" returntype="cfc.model.ShipMethod" output="false">
		<cfreturn variables.instance.ShipMethod />
	</cffunction>

	<cffunction name="setTrackingNumber" access="public" returntype="void" output="false">
		<cfargument name="TrackingNumber" type="string" required="true" />
		<cfset variables.instance.TrackingNumber = trim(arguments.TrackingNumber) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getTrackingNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.TrackingNumber />
	</cffunction>

	<cffunction name="setDeliveryStatus" access="public" returntype="void" output="false">
		<cfargument name="DeliveryStatus" type="string" required="true" />
		<cfset variables.instance.DeliveryStatus = trim(arguments.DeliveryStatus) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getDeliveryStatus" access="public" returntype="string" output="false">
		<cfreturn variables.instance.DeliveryStatus />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>