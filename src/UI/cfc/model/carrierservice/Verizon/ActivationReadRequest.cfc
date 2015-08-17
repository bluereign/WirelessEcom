<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">



	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>
	
	<cffunction name="setMtnInfoList" output="false" access="public" returntype="void">
		<cfargument name="MtnInfoList" type="cfc.model.carrierservice.Verizon.common.MtnInfo[]" default="0" required="false" />
		<cfset this.RequestBody.MtnInfoList = arguments.MtnInfoList />
	</cffunction>
	<cffunction name="getMtnInfoList" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.MtnInfo[]">
		<cfreturn this.RequestBody.MtnInfoList />
	</cffunction>


	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>