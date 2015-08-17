<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">



	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>
	
	<cffunction name="setPlanDetailsList" output="false" access="public" returntype="void">
		<cfargument name="PlanDetailsList" type="cfc.model.carrierservice.Verizon.common.PlanDetail[]" default="0" required="false" />
		<cfset this.RequestBody.CommonPlanDetails.PlanDetailsList = arguments.PlanDetailsList />
	</cffunction>
	<cffunction name="getPlanDetailsList" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PlanDetail[]">
		<cfreturn this.RequestBody.CommonPlanDetails.PlanDetailsList />
	</cffunction>
	
	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>