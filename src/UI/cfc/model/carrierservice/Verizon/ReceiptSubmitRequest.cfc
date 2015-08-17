<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">



	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>
	
	<cffunction name="setOrderType" output="false" access="public" returntype="void">
		<cfargument name="OrderType" type="string" required="true" /> <!--- NEW, UPGRADE, AAL --->
		<cfset this.RequestBody.OrderType = ' ' & arguments.OrderType />
	</cffunction>
	<cffunction name="getOrderType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.OrderType />
	</cffunction>
	
	<cffunction name="setContractReceiptSubmit" output="false" access="public" returntype="void">
		<cfargument name="ContractReceiptSubmit" type="string" required="true" />
		<cfset this.RequestBody.ContractReceiptSubmit = ' ' & arguments.ContractReceiptSubmit />
	</cffunction>
	<cffunction name="getContractReceiptSubmit" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContractReceiptSubmit />
	</cffunction>
	
	<cffunction name="setSignatureData" output="false" access="public" returntype="void">
		<cfargument name="SignatureData" type="string" required="true" />
		<cfset this.RequestBody.SignatureData = ' ' & arguments.SignatureData />
	</cffunction>
	<cffunction name="getSignatureData" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.SignatureData />
	</cffunction>
	
	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>