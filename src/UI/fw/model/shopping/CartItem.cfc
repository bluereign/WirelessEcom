<cfcomponent output="false" displayname="CartItem">

	<cffunction name="init" returntype="cfc.model.CartItem">
		<cfargument name="productID" type="numeric" required="false" default="0">
		<cfargument name="prices" type="any" required="false" default="#getModel('CartPriceBlock').init()#">
		<cfargument name="taxes" type="any" required="false" default="#getModel('CartPriceBlock').init()#">
		<cfargument name="type" type="string" required="false" default="">
        <cfargument name="title" type="string" required="false" default="" />
        <cfargument name="gersSKU" type="string" required="false" default="" />
		<cfargument name="DeviceServiceType" type="string" required="false" default="" /> <!--- SmartPhone, FeaturePhone, MobileBroadband --->
		<cfargument name="HasPlanDeviceCap" type="boolean" required="false" default="false" />
		<cfargument name="IsShared" type="boolean" required="false" default="false" />

		<cfscript>
			variables.instance = structNew();
			setProductID( arguments.productID );
			setPrices( arguments.prices );
			setTaxes( arguments.taxes );
			setType( arguments.type );
			setTitle( arguments.title );
			setGERSSKU( arguments.gersSKU );
			setDeviceServiceType( arguments.DeviceServiceType );
			setHasPlanDeviceCap( arguments.HasPlanDeviceCap );
			setIsShared( arguments.IsShared );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="hasBeenSelected" returntype="boolean">
		<cfreturn getProductID()>
	</cffunction>

	<!--- getters --->

	<cffunction name="getProductID" returntype="numeric" output="false">
		<cfreturn variables.instance.productID>
	</cffunction>

	<cffunction name="getPrices" returntype="any" output="false">
		<cfreturn variables.instance.prices>
	</cffunction>

	<cffunction name="getTaxes" returntype="any" output="false">
		<cfreturn variables.instance.taxes>
	</cffunction>

	<cffunction name="getType" returntype="string" output="false">
		<cfreturn variables.instance.type>
	</cffunction>

    <cffunction name="setTitle" access="public" returntype="void" output="false">
		<cfargument name="title" type="string" required="true" />
		<cfset variables.instance.title = arguments.title />
	</cffunction>

    <cffunction name="setGERSSKU" access="public" returntype="void" output="false">
		<cfargument name="gersSKU" type="string" required="true" />
		<cfset variables.instance.gersSKU = arguments.gersSKU />
	</cffunction>

	<cffunction name="getDeviceServiceType" returntype="string" output="false">
		<cfreturn variables.instance.DeviceServiceType />
	</cffunction>

	<cffunction name="getHasPlanDeviceCap" returntype="boolean" output="false">
		<cfreturn variables.instance.HasPlanDeviceCap />
	</cffunction>

	<cffunction name="getIsShared" returntype="boolean" output="false">
		<cfreturn variables.instance.IsShared />
	</cffunction>

	<!--- setters --->

	<cffunction name="setProductID" returntype="void">
		<cfargument name="productID" type="numeric" required="true">
		<cfset variables.instance.productID = arguments.productID>
	</cffunction>

	<cffunction name="setPrices" returntype="void">
		<cfargument name="prices" type="any" required="true">
		<cfset variables.instance.prices = arguments.prices>
	</cffunction>

	<cffunction name="setTaxes" returntype="void">
		<cfargument name="taxes" type="any" required="true">
		<cfset variables.instance.taxes = arguments.taxes>
	</cffunction>

	<cffunction name="setType" returntype="void">
		<cfargument name="type" type="string" required="true">
		<cfset variables.instance.type = arguments.type>
	</cffunction>

    <cffunction name="getTitle" access="public" returntype="string" output="false">
		<cfreturn variables.instance.title />
	</cffunction>

    <cffunction name="getGersSku" access="public" returntype="string" output="false">
		<cfreturn variables.instance.gersSKU />
	</cffunction>

	<cffunction name="setDeviceServiceType" returntype="void">
		<cfargument name="DeviceServiceType" type="string" required="true" />
		<cfset variables.instance.DeviceServiceType = arguments.DeviceServiceType />
	</cffunction>

	<cffunction name="setHasPlanDeviceCap" returntype="void">
		<cfargument name="HasPlanDeviceCap" type="boolean" required="true" />
		<cfset variables.instance.HasPlanDeviceCap = arguments.HasPlanDeviceCap />
	</cffunction>

	<cffunction name="setIsShared" returntype="void">
		<cfargument name="IsShared" type="boolean" required="true" />
		<cfset variables.instance.IsShared = arguments.IsShared />
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