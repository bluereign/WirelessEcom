<cfparam name="request.p.do" default="error" />

<!--- <cfdump var="#application.configMappingName#">
<cfdump var="#request.config#">
<cfabort /> --->

<cfset DynamicViewRenderer = application.wirebox.getInstance("DynamicViewRenderer")>
<cfset event = "emailTemplate.#request.p.do#">

<cfswitch expression="#request.p.do#">


	<cfcase value="forgotPassword">	
		<!--- setting values to be used in ForgotPassword.cfm template --->
		<cfset username = username />
		<cfset ssn = ssn />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />		
	</cfcase>
	
	<cfcase value="orderCancellation">	
		<!--- setting orderId to be used in OrderCancellation.cfm template --->
		<cfset orderId = orderId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="orderCancellationAlert">	
		<!--- setting orderId to be used in OrderCancellation.cfm template --->
		<cfset orderId = orderId />
		<cfset adminEmail = adminEmail />
		<cfset cancellationReason = cancellationReason />
		
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="orderConfirmation">	
		<!--- setting orderId to be used in OrderConfirmation.cfm template --->
		<cfset orderId = orderId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="delayNotification">	
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	
	<cfcase value="paymentExchange">	
		<!--- setting orderId to be used in OrderConfirmation.cfm template --->
		<cfset orderId = orderId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="paymentOrder">	
		<!--- setting orderId to be used in OrderConfirmation.cfm template --->
		<cfset orderId = orderId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="returnAuthorization">	
		<!--- setting orderId to be used in ReturnAuthorization.cfm template --->
		<cfset orderDetailId = orderDetailId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="TMONotification">	
		<!--- setting orderId to be used in ReturnAuthorization.cfm template --->
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
	
	<cfcase value="upgradeNotification">	
		<!--- setting upgradeId to be used in UpgradeNotification.cfm template --->
		<cfset upgradeId = upgradeId />
		<cfset viewPath = DynamicViewRenderer.getViewPath(event) />
	</cfcase>
</cfswitch>

<!--- include the template at the appropriate viewPath --->
<cfinclude template="#viewPath#" />