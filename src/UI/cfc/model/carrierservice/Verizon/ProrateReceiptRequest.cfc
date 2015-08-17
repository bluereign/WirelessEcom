<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	<cffunction name="setMobileNumber" output="false" access="public" returntype="void">
		<cfargument name="MobileNumber" type="string" default="0" required="false" />
		<cfset this.RequestBody.MobileNumber = ' ' & arguments.MobileNumber />
	</cffunction>
	<cffunction name="getMobileNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.MobileNumber />
	</cffunction>

	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>
	
	<cffunction name="setOrderType" output="false" access="public" returntype="void">
		<cfargument name="OrderType" type="string" default="0" required="false" />
		<cfset this.RequestBody.OrderType = arguments.OrderType />
	</cffunction>
	<cffunction name="getOrderType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.OrderType />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>