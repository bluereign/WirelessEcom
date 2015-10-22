<cfcomponent displayname="LineService" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("LineServiceId|OrderDetailId|ServiceType|ServiceId|CarrierServiceId|MonthlyFee|Mandatory", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.LineService" output="false">
		<cfargument name="LineServiceId" type="numeric" required="false" default="0" />
		<cfargument name="OrderDetailId" type="numeric" required="false" default="0" />
		<cfargument name="ServiceType" type="string" required="false" default="" />
		<cfargument name="ServiceId" type="numeric" required="false" default="0" />
		<cfargument name="CarrierServiceId" type="string" required="false" default="" />
		<cfargument name="MonthlyFee" type="numeric" required="false" default="0" />
		<cfargument name="Mandatory" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />

		<!--- run setters --->
		<cfset setLineServiceId(arguments.LineServiceId) />
		<cfset setOrderDetailId(arguments.OrderDetailId) />
		<cfset setServiceType(arguments.ServiceType) />
		<cfset setServiceId(arguments.ServiceId) />
		<cfset setCarrierServiceId(arguments.CarrierServiceId) />
		<cfset setMonthlyFee(arguments.MonthlyFee) />
		<cfset setMandatory(arguments.Mandatory) />

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="setMemento" access="public" returntype="cfc.model.LineService" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions
	">
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
		<cfargument name="id" type="string" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				LineServiceId
			,	OrderDetailId
			,	ServiceType
			,	ServiceId
			,	CarrierServiceId
			,	MonthlyFee
			,	Mandatory
			FROM
				SalesOrder.LineService
			WHERE
				LineServiceId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.LineServiceId))) this.setLineServiceId(local.qLoad.LineServiceId);
				if (len(trim(local.qLoad.OrderDetailId))) this.setOrderDetailId(local.qLoad.OrderDetailId);
				if (len(trim(local.qLoad.ServiceType))) this.setServiceType(local.qLoad.ServiceType);
				if (len(trim(local.qLoad.ServiceId))) this.setServiceId(local.qLoad.ServiceId);
				if (len(trim(local.qLoad.CarrierServiceId))) this.setCarrierServiceId(local.qLoad.CarrierServiceId);
				if (len(trim(local.qLoad.MonthlyFee))) this.setMonthlyFee(local.qLoad.MonthlyFee);
				if (len(trim(local.qLoad.Mandatory))) this.setMandatory(local.qLoad.Mandatory);
			}
			else
			{
				this = createObject("component","cfc.model.LineService").init();
			}
		</cfscript>

		<cfset this.setIsDirty(false)>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<cfif not this.getLineServiceId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO SalesOrder.LineService (
					OrderDetailId
				,	ServiceType
				,	ServiceId
				,	CarrierServiceId
				,	MonthlyFee
				,	Mandatory
				) VALUES (
					<cfif len(trim(this.getOrderDetailId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getServiceType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getServiceType()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getServiceId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getServiceId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierServiceId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierServiceId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMonthlyFee()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getMonthlyFee()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMandatory()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMandatory()#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfset this.setLineServiceId(local.saveResult.identitycol)>
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE SalesOrder.LineService SET
					OrderDetailId = <cfif len(trim(this.getOrderDetailId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#"><cfelse>NULL</cfif>
				,	ServiceType = <cfif len(trim(this.getServiceType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getServiceType()#"><cfelse>NULL</cfif>
				,	ServiceId = <cfif len(trim(this.getServiceId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getServiceId()#"><cfelse>NULL</cfif>
				,	CarrierServiceId = <cfif len(trim(this.getCarrierServiceId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierServiceId()#"><cfelse>NULL</cfif>
				,	MonthlyFee = <cfif len(trim(this.getMonthlyFee()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getMonthlyFee()#"><cfelse>NULL</cfif>
				,	Mandatory = <cfif len(trim(this.getMandatory()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMandatory()#"><cfelse>NULL</cfif>
				WHERE
					LineServiceId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getLineServiceId()#">
			</cfquery>
		</cfif>

		<cfset this.load(this.getLineServiceId())>
	</cffunction>

	<cffunction name="populateFromCartLineService" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfargument name="serviceNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartServices = arguments.cartLine.getFeatures()>
		<cfset local.cartService = local.cartServices[arguments.serviceNumber]>

		<!--- get the service --->
		<cfset local.s = local.cartService>
		<cfset local.sProduct = application.model.Feature.getByProductId(local.s.getProductId())>

		<cfif local.sProduct.recordCount>
			<!--- populate the LineService object --->
			<cfset this.setServiceType('service')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setServiceId(local.s.getProductId())>
			<cfset this.setCarrierServiceId(local.sProduct.CarrierBillCode)> 
			<cfif (cartLine.getCartLineActivationType() contains 'finance') AND (isDefined('local.sProduct.FinancedPrice') and len(local.sProduct.FinancedPrice))>
				<cfset this.setMonthlyFee(local.sProduct.FinancedPrice)>
			<cfelse>
				<cfset this.setMonthlyFee(local.sProduct.price)>
			</cfif>
			<!---<cfset this.setMonthlyFee(local.sProduct.price)>--->
			<cfset this.setMandatory(false)> <!--- TODO - not sure what value to populate this with --->
		</cfif>
	</cffunction>

	<cffunction name="getByOrderDetailId" access="public" output="false" returntype="cfc.model.LineService">
		<cfargument name="OrderDetailId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.o = createobject('component','cfc.model.LineService').init()>

		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				LineServiceId
			FROM
				SalesOrder.LineService
			WHERE
				OrderDetailId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OrderDetailId#">
		</cfquery>
		<cfif local.qGet.recordCount>
			<cfset local.o.load(local.qGet.LineServiceId[local.qGet.currentRow])>
		</cfif>
		<cfreturn local.o>
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setLineServiceId" access="public" returntype="void" output="false">
		<cfargument name="LineServiceId" type="numeric" required="true" />
		<cfset variables.instance.LineServiceId = trim(arguments.LineServiceId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineServiceId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.LineServiceId />
	</cffunction>

	<cffunction name="setOrderDetailId" access="public" returntype="void" output="false">
		<cfargument name="OrderDetailId" type="numeric" required="true" />
		<cfset variables.instance.OrderDetailId = trim(arguments.OrderDetailId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderDetailId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderDetailId />
	</cffunction>

	<cffunction name="setServiceType" access="public" returntype="void" output="false">
		<cfargument name="ServiceType" type="string" required="true" />
		<cfset variables.instance.ServiceType = trim(arguments.ServiceType) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getServiceType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ServiceType />
	</cffunction>

	<cffunction name="setServiceId" access="public" returntype="void" output="false">
		<cfargument name="ServiceId" type="numeric" required="true" />
		<cfset variables.instance.ServiceId = trim(arguments.ServiceId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getServiceId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ServiceId />
	</cffunction>

	<cffunction name="setCarrierServiceId" access="public" returntype="void" output="false">
		<cfargument name="CarrierServiceId" type="string" required="true" />
		<cfset variables.instance.CarrierServiceId = trim(arguments.CarrierServiceId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierServiceId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierServiceId />
	</cffunction>

	<cffunction name="setMonthlyFee" access="public" returntype="void" output="false">
		<cfargument name="MonthlyFee" type="numeric" required="true" />
		<cfset variables.instance.MonthlyFee = trim(arguments.MonthlyFee) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMonthlyFee" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.MonthlyFee />
	</cffunction>

	<cffunction name="setMandatory" access="public" returntype="void" output="false">
		<cfargument name="Mandatory" type="string" required="true" />
		<cfset variables.instance.Mandatory = trim(arguments.Mandatory) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMandatory" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Mandatory />
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