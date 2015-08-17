<cfcomponent output="false" displayname="DeviceAccessoryManager">

	<cffunction name="init" returntype="DeviceAccessoryManager">
    	<cfreturn this />
    </cffunction>

	<cffunction name="bulkAccessoryUpdate" access="public" returntype="string">
		<cfargument name="form" type="struct" required="true" />

		<cfset var local = {
				message = "",
				productId = arguments.form.productId,
				orderList = arguments.form.order
			} />
		
		<!--- set the display order, active, and default display of images --->
		<cfset local.orderCounter = 1 />
		<cfloop list="#local.orderList#" index="local.orderAccessory">
			<cfset application.model.Catalog.updateAccessoryForDevice(local.orderAccessory, local.productId, local.orderCounter) />
			<cfset local.orderCounter += 1 />
		</cfloop>
		
		<cfset local.message = "Success" />	
		<cfreturn local.message />
	</cffunction>
    
	<cffunction name="bulkFeaturedAccessoryUpdate" access="public" returntype="string">
		<cfargument name="form" type="struct" required="true" />


		<cfset var local = {
				message = "",
				productId = arguments.form.productId,
				orderList = arguments.form.order
			} />

		<!--- set the display order, active, and default display of images --->
		<cfset local.orderCounter = 1 />
		<cfloop list="#local.orderList#" index="local.orderAccessory">
			<cfset application.model.Catalog.updateFeaturedAccessoryForDevice(local.orderAccessory, local.productId, local.orderCounter) />
			<cfset local.orderCounter += 1 />
		</cfloop>
		
		<cfset local.message = "Success" />	
		<cfreturn local.message />
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
 
</cfcomponent>