<!--- 
	Provides method signatures for each concrete payment gateway to implement
--->
<cfinterface hint="Payment gateway interface">
	
	<cffunction name="signHash" access="public" returntype="string" output="true">
		<cfargument name="str" type="string" required="true" />
	</cffunction>
	
	<cffunction name="processPaymentResult" access="public" returntype="any" output="false">
		<cfargument name="form" type="struct" required="true" />
	</cffunction>
	
	<cffunction name="buildGatewayFormAction" access="public" returntype="string" output="false">
	</cffunction>
	
	<cffunction name="buildGatewayFormElements" access="public" returntype="string" output="false">
		<cfargument name="gatewayId" type="string" required="true" />
		<cfargument name="billingAddress" type="cfc.model.Address" required="false" />
		<cfargument name="shippingAddress" type="cfc.model.Address" required="false" />
		<cfargument name="email" type="string" required="true" />
		<cfargument name="userId" type="string" required="true" />
		<cfargument name="phone" type="string" required="true" />
		<cfargument name="totalPrice" type="numeric" required="true" />
		<cfargument name="salesOrderNumber" type="string" required="true" />
		<cfargument name="sendCustomerEmailReceipt" type="string" required="false" default="" />
		<cfargument name="sendMerchantEmailReceipt" type="string" required="false" default="" />
		<cfargument name="returnUrl" type="string" required="true" />
		<cfargument name="description" type="string" required="false" default="" />
		<cfargument name="qty" type="numeric" required="true" default="1" />
		<cfargument name="enablePreAuth" required="false" type="boolean" default="false" />
		<cfargument name="disableTestMode" required="false" type="boolean" default="true" />
		<cfargument name="testModeType" required="false" type="string" default="decline" />
		<cfargument name="billingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="shippingOrderAddress" type="cfc.model.OrderAddress" required="false" />
		<cfargument name="trx" type="string" required="false" default="" />
		<cfargument name="guid" type="string" required="false" default="" />
		<cfargument name="shouldCapture" type="boolean" required="false" default="false" />
		<cfargument name="saveToCustomerDB" type="numeric" required="false" default="1" />
	</cffunction>
	
</cfinterface>