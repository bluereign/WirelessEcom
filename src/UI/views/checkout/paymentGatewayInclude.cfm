<!--- SCINSS requires a back link URL to make its "back" button return to the appropriate place during checkout. --->
<cfparam name="variables.backLinkURL" default="" />
<cfparam name="variables.fwdLinkURL" default="" /><!--- This is actually a url to the suspected fraud listener --->
<cfparam name="variables.errLinkURL" default="" /><!--- This is actually a url to display an error message --->
<cfparam name="forceMultipleGateways" default="false" />

<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry")>
<cfset PaymentService = application.wirebox.getInstance("PaymentService")>

<cfset Order = createObject('component', 'cfc.model.Order').init()>
<cfset Order.load( application.model.checkoutHelper.getOrderID() )>

<!--- If gateway has been determined, use it.  Else, look up by payment method in registry --->
<cfif isNumeric( Order.getPaymentGatewayID() ) && Order.getPaymentGatewayID() GT 0>
	<cfset PaymentGateway = PaymentService.getPaymentGatewayByID( Order.getPaymentGatewayID() )>
<cfelse>
	<cfset PaymentGateway = GatewayRegistry.findGateway( application.model.checkoutHelper.getPaymentMethod() )>
	<!--- Associate gateway to order --->
	<cfset Order.setPaymentGatewayID( PaymentService.getPaymentGatewayIDByName( PaymentGateway.getName() ) )>
	<cfset Order.save()>
</cfif>

<cfset paymentData = PaymentService.getPaymentData()>

<!--- build the server_name with the port address if it is non 80 --->
<cfset local.server_name = cgi.server_name />
<cfif cgi.server_port is not 80>
	<cfset local.server_name = local.server_name & ":#cgi.server_port#" />
</cfif>	

<!--- If mutiple gateways are registered, we use a JS redirect to the gateway. Rather than leave the user in an endless loop, send them to the paymentOptions page --->
<cfif !len(variables.backLinkURL)>
	<cfif GatewayRegistry.hasMultipleRegistered()>
		<cfset backLinkURL = local.server_name & "/index.cfm/go/checkout/do/paymentOptions">
	<cfelse>
		<cfset backLinkURL = local.server_name & cgi.script_name & cgi.path_info>
	</cfif>
</cfif>

<!--- Prepend protocol to backLinkURL if it wasn't provided --->
<cfif left(backLinkURL, 4 ) neq "http" && request.config.disableSSL>
	<cfset backLinkURL = "http://" & backLinkURL>
<cfelseif left( backLinkURL, 4 ) neq "http">
	<cfset backLinkURL = "https://" & backLinkURL>
</cfif>

<!--- build the fwdLinkUrl (suspected fraud asynclistener) --->
<cfset variables.fwdLinkURL = cgi.server_name & "/AsyncListner/FwdPaymentGatewayAsyncListener.cfm" />
<!--- Prepend protocol to fwdLinkURL if it wasn't provided --->
<cfif left(fwdLinkURL, 4 ) neq "http" && request.config.disableSSL>
	<cfset fwdLinkURL = "http://" & fwdLinkURL>
<cfelseif left( fwdLinkURL, 4 ) neq "http">
	<cfset fwdLinkURL = "https://" & fwdLinkURL>
</cfif>
<!--- build the errLinkUrl (suspected fraud asynclistener) --->
<cfset variables.errLinkURL = cgi.server_name & "/index.cfm/go/checkout/do/checkoutError" />
<!--- Prepend protocol to errLinkURL if it wasn't provided --->
<cfif left(errLinkURL, 4 ) neq "http" && request.config.disableSSL>
	<cfset errLinkURL = "http://" & errLinkURL>
<cfelseif left( errLinkURL, 4 ) neq "http">
	<cfset errLinkURL = "https://" & errLinkURL>
</cfif>


<cfset paymentData.backLinkURL = variables.backLinkURL>
<cfset paymentData.fwdLinkURL = variables.fwdLinkURL>
<cfset paymentData.errLinkURL = variables.errLinkURL>

<cfset formFields = PaymentGateway.buildGatewayFormElements( argumentCollection=paymentData )>
<cfset formAction = PaymentGateway.buildGatewayFormAction()>

<!--- Bug 6319: override form action if there are multiple payment gateways and force flag is set --->
<cfif forceMultipleGateways is true and GatewayRegistry.hasMultipleRegistered()>
	<cfset formAction = paymentData.backLinkURL />
</cfif>
	
<cfset paymentLogArgs = {
	OrderId = application.model.checkoutHelper.getOrderId()
	, Type = 'Request'
	, RequestType = 'Post'
	, Data = formFields
} />

<cfset application.model.Log.logPaymentGatewayResponse( argumentCollection = paymentLogArgs ) />

<cfoutput>
	<form id="paymentForm" class="cmxform" action="#trim(variables.formAction)#" method="post">
		<cfoutput>#trim(variables.formFields)#</cfoutput>
	</form>
</cfoutput>
