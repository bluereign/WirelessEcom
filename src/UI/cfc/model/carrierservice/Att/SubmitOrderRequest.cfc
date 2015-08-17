<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">
 
 <!---
 
      <d3p1:>0</d3p1:ActivationType>
      <d3p1:>String</d3p1:ApprovalNumber>
      <d3p1:>String</d3p1:BillingAccountNumber>
      <d3p1:FamilyPlan>false</d3p1:FamilyPlan>
      <d3p1:>String</d3p1:NewSalesChannel>
      <d3p1:>
      <d3p1:>String</d3p1:PIN>
      <d3p1:>0</d3p1:QtySubscriberNumbers>
      <d3p1:>String</d3p1:SSN>
      <d3p1:>String</d3p1:ServiceZipCode>

 --->
 
	<cffunction name="setActivationType" output="false" access="public" returntype="void">
		<cfargument name="ActivationType" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.ActivationType = ' ' & arguments.ActivationType />
	</cffunction>
	<cffunction name="getActivationType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.ActivationType />
	</cffunction>
	
	<cffunction name="setApprovalNumber" output="false" access="public" returntype="void">
		<cfargument name="ApprovalNumber" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.ApprovalNumber = ' ' & arguments.ApprovalNumber />
	</cffunction>
	<cffunction name="getApprovalNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.ApprovalNumber />
	</cffunction>
	
	<cffunction name="setBillingAccountNumber" output="false" access="public" returntype="void">
		<cfargument name="BillingAccountNumber" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.BillingAccountNumber = ' ' & arguments.BillingAccountNumber />
	</cffunction>
	<cffunction name="getBillingAccountNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.BillingAccountNumber />
	</cffunction>

	<cffunction name="setFamilyPlan" output="false" access="public" returntype="void">
		<cfargument name="FamilyPlan" type="boolean" default="false" required="false" />
		<cfset this.RequestBody.Order.FamilyPlan = arguments.FamilyPlan />
	</cffunction>
	<cffunction name="getFamilyPlan" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.FamilyPlan />
	</cffunction>
	
	<cffunction name="setNewSalesChannel" output="false" access="public" returntype="void">
		<cfargument name="NewSalesChannel" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.NewSalesChannel = ' ' & arguments.NewSalesChannel />
	</cffunction>
	<cffunction name="getNewSalesChannel" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.NewSalesChannel />
	</cffunction>
	
	<cffunction name="setPin" output="false" access="public" returntype="void">
		<cfargument name="Pin" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.Pin = ' ' & arguments.Pin />
	</cffunction>
	<cffunction name="getPin" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.Pin />
	</cffunction>
	
	<cffunction name="setQtySubscriberNumbers" output="false" access="public" returntype="void">
		<cfargument name="QtySubscriberNumbers" type="numeric" default="0" required="false" />
		<cfset this.RequestBody.Order.QtySubscriberNumbers = arguments.QtySubscriberNumbers />
	</cffunction>
	<cffunction name="getQtySubscriberNumbers" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.QtySubscriberNumbers />
	</cffunction>		

	<cffunction name="setSSN" output="false" access="public" returntype="void">
		<cfargument name="SSN" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.SSN = ' ' & arguments.SSN />
	</cffunction>
	<cffunction name="getSSN" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.SSN />
	</cffunction>

	<cffunction name="setServiceZipCode" output="false" access="public" returntype="void">
		<cfargument name="ServiceZipCode" type="string" default="0" required="false" />
		<cfset this.RequestBody.Order.ServiceZipCode = ' ' & arguments.ServiceZipCode />
	</cffunction>
	<cffunction name="getServiceZipCode" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Order.ServiceZipCode />
	</cffunction>

	<cffunction name="setOrderDetails" output="false" access="public" returntype="void">
		<cfargument name="OrderDetails" type="array" default="#ArrayNew(1)#" required="false" />
		<cfset this.RequestBody.Order.OrderDetails = arguments.OrderDetails />
	</cffunction>
	<cffunction name="getOrderDetails" output="false" access="public" returntype="array">
		<cfreturn this.RequestBody.Order.OrderDetails />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>